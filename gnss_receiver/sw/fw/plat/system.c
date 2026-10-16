/* МГП-8: тактирование STM32H743, MPU, кеши, SysTick, счётчик тактов DWT, сторожевой таймер.
 *
 * Тактирование (HSE — внешний сигнал 24 МГц ТСХО на PH0, режим обхода генератора):
 *   PLL1: вход 8 МГц (HSE/3 или HSI/8), ГУН 960 МГц (рев. V) или 800 МГц (рев. Y);
 *   P — ядро 480/400 МГц, Q — 192/160 МГц (SDMMC, FDCAN при отсутствии HSE), R — не используется;
 *   AXI/AHB — ядро/2, APB1–4 — AHB/2. Напряжение ядра — VOS0 (рев. V, 480 МГц) или VOS1.
 *   Без HSE — от HSI 64 МГц через PLL1 (точность ±1 %, для UART достаточно).
 * MPU: окно FMC 0x60000000 (1 МБ, регистры ПЛИС) — Device, без исполнения; остальное адресное
 * пространство FMC (0x60000000–0x9FFFFFFF) — без доступа, чтобы ядро не выполняло упреждающих
 * обращений к несуществующей памяти. Прочие области — по карте памяти по умолчанию (PRIVDEFENA).
 * Кеши I и D включены: ПДП не используется, буферы ПЛИС читаются через окно Device. */
#include "plat.h"

uint32_t sys_hz = 64000000u, hclk_hz = 64000000u, pclk_hz = 64000000u, pll1q_hz;
uint32_t sys_rev;
int sys_hse;
volatile uint32_t sys_ms;

static void dwt_init(void)
{
    DEMCR |= 1u << 24;                          /* TRCENA */
    DWT_LAR = 0xC5ACCE55u;
    DWT_CTRL |= 1u;                             /* CYCCNTENA */
}

static int wait_bits(volatile uint32_t *r, uint32_t m, uint32_t v, uint32_t us)
{
    uint32_t t0 = DWT_CYCCNT, n = us * (sys_hz / 1000000u);
    while ((*r & m) != v)
        if (DWT_CYCCNT - t0 > n) return -1;
    return 0;
}

void delay_us(uint32_t us)
{
    uint32_t t0 = DWT_CYCCNT, n = us * (sys_hz / 1000000u);
    while (DWT_CYCCNT - t0 < n) {}
}

static void mpu_init(void)
{
    DSB();
    MPU_CTRL = 0;
    MPU_RNR = 0; MPU_RBAR = 0x60000000u; MPU_RASR = RASR_SIZE(29) | RASR_AP(0) | RASR_XN | RASR_EN;
    MPU_RNR = 1; MPU_RBAR = 0x60000000u; MPU_RASR = RASR_SIZE(20) | RASR_B | RASR_AP(3) | RASR_XN | RASR_EN;
    MPU_RNR = 2; MPU_RBAR = 0x80000000u; MPU_RASR = RASR_SIZE(29) | RASR_AP(0) | RASR_XN | RASR_EN;
    MPU_CTRL = MPU_ENABLE | MPU_PRIVDEF;
    SCB_SHCSR |= SHCSR_FAULTS;
    DSB(); ISB();
}

static void cache_init(void)
{
    DSB(); ISB();
    SCB_ICIALLU = 0;
    DSB(); ISB();
    SCB_CCR |= CCR_IC;
    DSB(); ISB();
    SCB_CSSELR = 0;                             /* кеш данных L1 */
    DSB();
    uint32_t id = SCB_CCSIDR, sets = (id >> 13) & 0x7FFFu, ways = (id >> 3) & 0x3FFu;
    for (uint32_t s = 0; s <= sets; s++)
        for (uint32_t w = 0; w <= ways; w++) SCB_DCISW = s << 5 | w << 30;
    DSB();
    SCB_CCR |= CCR_DC;
    DSB(); ISB();
}

void sys_tick_init(void)
{
    dwt_init();
    SYST_CSR = 0;
    SYST_RVR = sys_hz / 1000u - 1u;
    SYST_CVR = 0;
    SCB_SHPR3 = (SCB_SHPR3 & 0x0000FFFFu) | 0xF0u << 16 | 0x30u << 24;   /* PendSV, SysTick */
    SYST_CSR = 7u;                              /* такт ядра, прерывание, пуск */
}

void SysTick_Handler(void) { sys_ms++; }

int sys_init(void)
{
    dwt_init();
    sys_rev = DBGMCU_IDCODE >> 16;
    int rev_v = sys_rev >= 0x2000u;
    /* питание ядра от LDO; масштаб напряжения VOS1, для рев. V — VOS0 (ODEN) */
    PWR_CR3 = (PWR_CR3 & ~5u) | 2u;
    wait_bits(&PWR_CSR1, 1u << 13, 1u << 13, 10000);
    PWR_D3CR |= 3u << 14;
    wait_bits(&PWR_D3CR, 1u << 13, 1u << 13, 10000);
    if (rev_v) {
        RCC_APB4ENR |= APB4_SYSCFG;
        (void)RCC_APB4ENR;
        SYSCFG_PWRCR |= 1u;
        wait_bits(&PWR_D3CR, 1u << 13, 1u << 13, 10000);
    }
    /* HSE: внешний сигнал 24 МГц */
    RCC_CR |= CR_HSEBYP;
    RCC_CR |= CR_HSEON;
    sys_hse = wait_bits(&RCC_CR, CR_HSERDY, CR_HSERDY, 10000) == 0;
    if (!sys_hse) { RCC_CR &= ~CR_HSEON; RCC_CR &= ~CR_HSEBYP; }
    /* такты ожидания флеш-памяти до повышения частоты: 4 (240 МГц, VOS0) или 2 (200 МГц, VOS1) */
    RCC_D1CFGR = 8u | 4u << 4;                  /* HPRE /2, D1PPRE /2, D1CPRE /1 */
    RCC_D2CFGR = 4u << 4 | 4u << 8;             /* D2PPRE1, D2PPRE2 /2 */
    RCC_D3CFGR = 4u << 4;                       /* D3PPRE /2 */
    hclk_hz = sys_hz / 2u;
    pclk_hz = hclk_hz / 2u;
    uint32_t acr = rev_v ? 0x24u : 0x22u, n = rev_v ? 120u : 100u;
    FLASH_ACR = acr;
    int r = wait_bits(&FLASH_ACR, 0x3Fu, acr, 1000);
    if (r == 0) {
        RCC_PLLCKSELR = (RCC_PLLCKSELR & ~(3u | 0x3Fu << 4)) | (sys_hse ? 2u : 0u) | (sys_hse ? 3u : 8u) << 4;
        RCC_PLLCFGR = (RCC_PLLCFGR & ~(0xFu | 7u << 16)) | 3u << 2 | 7u << 16;   /* вход 8–16 МГц, широкий ГУН, P Q R */
        RCC_PLL1DIVR = (n - 1u) | 1u << 9 | 4u << 16 | 1u << 24;                /* N, P = 2, Q = 5, R = 2 */
        RCC_CR |= CR_PLL1ON;
        r = wait_bits(&RCC_CR, CR_PLL1RDY, CR_PLL1RDY, 10000);
    }
    if (r == 0) {
        RCC_CFGR = (RCC_CFGR & ~7u) | 3u;
        r = wait_bits(&RCC_CFGR, 7u << 3, 3u << 3, 10000);
    }
    if (r == 0) {
        sys_hz = 8000000u * n / 2u;
        hclk_hz = sys_hz / 2u;
        pclk_hz = hclk_hz / 2u;
        pll1q_hz = 8000000u * n / 5u;
    }
    mpu_init();
    cache_init();
    sys_tick_init();
    return r;
}

void sys_reset(void)
{
    DSB();
    SCB_AIRCR = AIRCR_KEY | (SCB_AIRCR & 0x700u) | AIRCR_SYSRESET;
    DSB();
    for (;;) {}
}

void irq_prio(int irq, uint32_t prio) { NVIC_IPR(irq) = (uint8_t)prio; }
void irq_on(int irq) { NVIC_ISER((uint32_t)irq >> 5) = 1u << (irq & 31); }
void irq_pend(int irq) { NVIC_ISPR((uint32_t)irq >> 5) = 1u << (irq & 31); }
void irq_off(int irq)
{
    NVIC_ICER((uint32_t)irq >> 5) = 1u << (irq & 31);
    DSB(); ISB();
}

/* блокировка прикладного уровня: маскирует прерывание ПЛИС, SysTick и PendSV */
void irq_lock(int on)
{
    if (on) basepri_raise(0x20u);
    else basepri_set(0);
}

/* IWDG1 от LSI 32 кГц: делитель 64 (2 мс, до 8 с) или 256 (8 мс, до 32 с) */
void wdg_start(uint32_t ms)
{
    uint32_t pr = ms <= 8000u ? 4u : 6u, rl = ms / (pr == 4u ? 2u : 8u);
    if (rl > 4095u) rl = 4095u;
    if (rl < 1u) rl = 1u;
    IWDG_KR = 0xCCCCu;
    IWDG_KR = 0x5555u;
    IWDG_PR = pr;
    IWDG_RLR = rl;
    wait_bits(&IWDG_SR, 7u, 0, 100000);
    IWDG_KR = 0xAAAAu;
}

void wdg_kick(void) { IWDG_KR = 0xAAAAu; }
