/* МГП-8: регистры STM32H743 и ядра Cortex-M7, используемые платформенной частью ПО МК.
 * Адреса и поля — по RM0433 (ред. 8) и PM0253; файл заменяет CMSIS-заголовки ST, чтобы сборка
 * не зависела от внешних пакетов. Перед первым включением образца сверить с RM0433
 * (или с stm32h743xx.h из STM32CubeH7) — проверка отмечена в ПЗ, п. 4.5.3. */
#ifndef STM32H743_H
#define STM32H743_H
#include <stdint.h>

#define REG(a)          (*(volatile uint32_t *)(uintptr_t)(a))

/* --- ядро Cortex-M7 */
#define SCB_ICSR        REG(0xE000ED04u)
#define SCB_VTOR        REG(0xE000ED08u)
#define SCB_AIRCR       REG(0xE000ED0Cu)
#define SCB_SCR         REG(0xE000ED10u)
#define SCB_CCR         REG(0xE000ED14u)
#define SCB_SHPR2       REG(0xE000ED1Cu)            /* [31:24] SVCall */
#define SCB_SHPR3       REG(0xE000ED20u)            /* [23:16] PendSV, [31:24] SysTick */
#define SCB_SHCSR       REG(0xE000ED24u)
#define SCB_CFSR        REG(0xE000ED28u)
#define SCB_HFSR        REG(0xE000ED2Cu)
#define SCB_MMFAR       REG(0xE000ED34u)
#define SCB_BFAR        REG(0xE000ED38u)
#define SCB_CCSIDR      REG(0xE000ED80u)
#define SCB_CSSELR      REG(0xE000ED84u)
#define SCB_CPACR       REG(0xE000ED88u)
#define SCB_ICIALLU     REG(0xE000EF50u)
#define SCB_DCISW       REG(0xE000EF60u)
#define SCB_DCCISW      REG(0xE000EF74u)
#define ICSR_PENDSVSET  (1u << 28)
#define AIRCR_KEY       (0x05FAu << 16)
#define AIRCR_SYSRESET  (1u << 2)
#define CCR_DC          (1u << 16)
#define CCR_IC          (1u << 17)
#define SHCSR_FAULTS    (7u << 16)                  /* MEMFAULTENA, BUSFAULTENA, USGFAULTENA */

#define NVIC_ISER(n)    REG(0xE000E100u + 4u * (n))
#define NVIC_ICER(n)    REG(0xE000E180u + 4u * (n))
#define NVIC_ISPR(n)    REG(0xE000E200u + 4u * (n))
#define NVIC_ICPR(n)    REG(0xE000E280u + 4u * (n))
#define NVIC_IPR(i)     (*(volatile uint8_t *)(uintptr_t)(0xE000E400u + (uint32_t)(i)))

#define SYST_CSR        REG(0xE000E010u)
#define SYST_RVR        REG(0xE000E014u)
#define SYST_CVR        REG(0xE000E018u)

#define DEMCR           REG(0xE000EDFCu)            /* [24] TRCENA */
#define DWT_CTRL        REG(0xE0001000u)
#define DWT_CYCCNT      REG(0xE0001004u)
#define DWT_LAR         REG(0xE0001FB0u)

#define MPU_CTRL        REG(0xE000ED94u)
#define MPU_RNR         REG(0xE000ED98u)
#define MPU_RBAR        REG(0xE000ED9Cu)
#define MPU_RASR        REG(0xE000EDA0u)
#define MPU_ENABLE      1u
#define MPU_PRIVDEF     4u
#define RASR_EN         1u
#define RASR_SIZE(l2)   ((uint32_t)((l2) - 1) << 1)    /* размер 2^l2 байт */
#define RASR_B          (1u << 16)
#define RASR_C          (1u << 17)
#define RASR_S          (1u << 18)
#define RASR_TEX(t)     ((uint32_t)(t) << 19)
#define RASR_AP(a)      ((uint32_t)(a) << 24)          /* 0 — нет доступа, 3 — полный */
#define RASR_XN         (1u << 28)

/* номера прерываний (RM0433, табл. 147) */
enum {
    IRQ_ADC1_2 = 18, IRQ_FDCAN1_IT0 = 19, IRQ_EXTI9_5 = 23, IRQ_USART1 = 37, IRQ_SDMMC1 = 49, IRQ_UART4 = 52,
    NIRQ = 150
};

/* --- RCC */
#define RCC_BASE        0x58024400u
#define RCC_CR          REG(RCC_BASE + 0x000u)
#define RCC_CFGR        REG(RCC_BASE + 0x010u)
#define RCC_D1CFGR      REG(RCC_BASE + 0x018u)
#define RCC_D2CFGR      REG(RCC_BASE + 0x01Cu)
#define RCC_D3CFGR      REG(RCC_BASE + 0x020u)
#define RCC_PLLCKSELR   REG(RCC_BASE + 0x028u)
#define RCC_PLLCFGR     REG(RCC_BASE + 0x02Cu)
#define RCC_PLL1DIVR    REG(RCC_BASE + 0x030u)
#define RCC_D1CCIPR     REG(RCC_BASE + 0x04Cu)
#define RCC_D2CCIP1R    REG(RCC_BASE + 0x050u)
#define RCC_D2CCIP2R    REG(RCC_BASE + 0x054u)
#define RCC_D3CCIPR     REG(RCC_BASE + 0x058u)
#define RCC_RSR         REG(RCC_BASE + 0x0D0u)
#define RCC_AHB3ENR     REG(RCC_BASE + 0x0D4u)
#define RCC_AHB1ENR     REG(RCC_BASE + 0x0D8u)
#define RCC_AHB2ENR     REG(RCC_BASE + 0x0DCu)
#define RCC_AHB4ENR     REG(RCC_BASE + 0x0E0u)
#define RCC_APB1LENR    REG(RCC_BASE + 0x0E8u)
#define RCC_APB1HENR    REG(RCC_BASE + 0x0ECu)
#define RCC_APB2ENR     REG(RCC_BASE + 0x0F0u)
#define RCC_APB4ENR     REG(RCC_BASE + 0x0F4u)
#define CR_HSION        (1u << 0)
#define CR_HSIRDY       (1u << 2)
#define CR_HSEON        (1u << 16)
#define CR_HSERDY       (1u << 17)
#define CR_HSEBYP       (1u << 18)
#define CR_PLL1ON       (1u << 24)
#define CR_PLL1RDY      (1u << 25)
#define AHB3_FMC        (1u << 12)
#define AHB3_SDMMC1     (1u << 16)
#define AHB1_ADC12      (1u << 5)
#define AHB2_SRAM123    (7u << 29)
#define AHB4_ADC3       (1u << 24)
#define APB1L_UART4     (1u << 19)
#define APB1H_FDCAN     (1u << 8)
#define APB2_USART1     (1u << 4)
#define APB4_SYSCFG     (1u << 1)
#define RSR_RMVF        (1u << 16)

/* --- PWR, SYSCFG, флеш-память, идентификатор */
#define PWR_BASE        0x58024800u
#define PWR_CSR1        REG(PWR_BASE + 0x04u)        /* [13] ACTVOSRDY */
#define PWR_CR3         REG(PWR_BASE + 0x0Cu)        /* [0] BYPASS, [1] LDOEN, [2] SCUEN */
#define PWR_D3CR        REG(PWR_BASE + 0x18u)        /* [15:14] VOS, [13] VOSRDY */
#define SYSCFG_BASE     0x58000400u
#define SYSCFG_EXTICR(n) REG(SYSCFG_BASE + 0x08u + 4u * (n))
#define SYSCFG_PWRCR    REG(SYSCFG_BASE + 0x2Cu)     /* [0] ODEN */
#define FLASH_BASE_R    0x52002000u
#define FLASH_ACR       REG(FLASH_BASE_R + 0x00u)    /* [3:0] LATENCY, [5:4] WRHIGHFREQ */
#define FLASH_KEYR(b)   REG(FLASH_BASE_R + 0x04u + 0x100u * (b))
#define FLASH_CR(b)     REG(FLASH_BASE_R + 0x0Cu + 0x100u * (b))
#define FLASH_SR(b)     REG(FLASH_BASE_R + 0x10u + 0x100u * (b))
#define FLASH_CCR(b)    REG(FLASH_BASE_R + 0x14u + 0x100u * (b))
#define FCR_LOCK        (1u << 0)
#define FCR_PG          (1u << 1)
#define FCR_SER         (1u << 2)
#define FCR_PSIZE32     (2u << 4)
#define FCR_START       (1u << 7)
#define FCR_SNB(s)      ((uint32_t)(s) << 8)
#define FSR_BSY         (1u << 0)
#define FSR_WBNE        (1u << 1)
#define FSR_QW          (1u << 2)
#define FSR_ERR         0x07EE0000u                  /* WRPERR … DBECCERR */
#define FCCR_ALL        0x0FEF0000u
#define DBGMCU_IDCODE   REG(0x5C001000u)             /* [31:16] REV_ID: 0x1003 — Y, 0x2003 — V */
#define IWDG_KR         REG(0x58004800u)
#define IWDG_PR         REG(0x58004804u)
#define IWDG_RLR        REG(0x58004808u)
#define IWDG_SR         REG(0x5800480Cu)

/* --- GPIO (порт A … K с шагом 0x400) */
#define GPIO_BASE(p)    (0x58020000u + 0x400u * (uint32_t)(p))
#define GPIO_MODER(p)   REG(GPIO_BASE(p) + 0x00u)
#define GPIO_OTYPER(p)  REG(GPIO_BASE(p) + 0x04u)
#define GPIO_OSPEEDR(p) REG(GPIO_BASE(p) + 0x08u)
#define GPIO_PUPDR(p)   REG(GPIO_BASE(p) + 0x0Cu)
#define GPIO_IDR(p)     REG(GPIO_BASE(p) + 0x10u)
#define GPIO_BSRR(p)    REG(GPIO_BASE(p) + 0x18u)
#define GPIO_AFR(p, h)  REG(GPIO_BASE(p) + 0x20u + 4u * (h))

/* --- EXTI (прерывания ядра D1) */
#define EXTI_RTSR1      REG(0x58000000u)
#define EXTI_FTSR1      REG(0x58000004u)
#define EXTI_CPUIMR1    REG(0x58000080u)
#define EXTI_CPUPR1     REG(0x58000088u)

/* --- FMC (банк 1 NOR/PSRAM, 0x60000000) */
#define FMC_BCR1        REG(0x52004000u)
#define FMC_BTR1        REG(0x52004004u)

/* --- USART/UART */
#define USART1_BASE     0x40011000u
#define UART4_BASE      0x40004C00u
#define U_CR1(b)        REG((b) + 0x00u)
#define U_CR2(b)        REG((b) + 0x04u)
#define U_CR3(b)        REG((b) + 0x08u)
#define U_BRR(b)        REG((b) + 0x0Cu)
#define U_ISR(b)        REG((b) + 0x1Cu)
#define U_ICR(b)        REG((b) + 0x20u)
#define U_RDR(b)        REG((b) + 0x24u)
#define U_TDR(b)        REG((b) + 0x28u)
#define UCR1_UE         (1u << 0)
#define UCR1_RE         (1u << 2)
#define UCR1_TE         (1u << 3)
#define UCR1_RXNEIE     (1u << 5)
#define UCR1_TXEIE      (1u << 7)
#define UCR1_FIFOEN     (1u << 29)
#define UISR_ERR        0x0Fu                        /* PE, FE, NE, ORE */
#define UISR_RXNE       (1u << 5)
#define UISR_TC         (1u << 6)
#define UISR_TXE        (1u << 7)

/* --- FDCAN1, ОЗУ сообщений (10 КБ, общее для FDCAN1/2) */
#define FDCAN1_BASE     0x4000A000u
#define FDCAN_RAM       0x4000AC00u
#define CAN_CCCR        REG(FDCAN1_BASE + 0x018u)    /* [0] INIT, [1] CCE */
#define CAN_NBTP        REG(FDCAN1_BASE + 0x01Cu)
#define CAN_ECR         REG(FDCAN1_BASE + 0x040u)
#define CAN_PSR         REG(FDCAN1_BASE + 0x044u)
#define CAN_IR          REG(FDCAN1_BASE + 0x050u)
#define CAN_GFC         REG(FDCAN1_BASE + 0x080u)
#define CAN_SIDFC       REG(FDCAN1_BASE + 0x084u)
#define CAN_XIDFC       REG(FDCAN1_BASE + 0x088u)
#define CAN_RXF0C       REG(FDCAN1_BASE + 0x0A0u)
#define CAN_RXF0S       REG(FDCAN1_BASE + 0x0A4u)
#define CAN_RXF0A       REG(FDCAN1_BASE + 0x0A8u)
#define CAN_RXESC       REG(FDCAN1_BASE + 0x0BCu)
#define CAN_TXBC        REG(FDCAN1_BASE + 0x0C0u)
#define CAN_TXFQS       REG(FDCAN1_BASE + 0x0C4u)
#define CAN_TXESC       REG(FDCAN1_BASE + 0x0C8u)
#define CAN_TXBAR       REG(FDCAN1_BASE + 0x0D0u)

/* --- SDMMC1 */
#define SDMMC1_BASE     0x52007000u
#define SD_POWER        REG(SDMMC1_BASE + 0x00u)
#define SD_CLKCR        REG(SDMMC1_BASE + 0x04u)
#define SD_ARGR         REG(SDMMC1_BASE + 0x08u)
#define SD_CMDR         REG(SDMMC1_BASE + 0x0Cu)
#define SD_RESP(n)      REG(SDMMC1_BASE + 0x14u + 4u * (n))
#define SD_DTIMER       REG(SDMMC1_BASE + 0x24u)
#define SD_DLENR        REG(SDMMC1_BASE + 0x28u)
#define SD_DCTRL        REG(SDMMC1_BASE + 0x2Cu)
#define SD_STAR         REG(SDMMC1_BASE + 0x34u)
#define SD_ICR          REG(SDMMC1_BASE + 0x38u)
#define SD_FIFO         REG(SDMMC1_BASE + 0x80u)

/* --- АЦП: ADC1 и ADC2 (ADC12: напряжения, ток антенны), ADC3 (датчик температуры) */
#define ADC1_BASE       0x40022000u
#define ADC2_BASE       0x40022100u
#define ADC12_COMMON    0x40022300u
#define ADC3_BASE       0x58026000u
#define ADC3_COMMON     0x58026300u
#define ADC_ISR(b)      REG((b) + 0x00u)
#define ADC_IER(b)      REG((b) + 0x04u)
#define ADC_CR(b)       REG((b) + 0x08u)
#define ADC_CFGR(b)     REG((b) + 0x0Cu)
#define ADC_SMPR(b, h)  REG((b) + 0x14u + 4u * (h))
#define ADC_PCSEL(b)    REG((b) + 0x1Cu)
#define ADC_LTR1(b)     REG((b) + 0x20u)
#define ADC_HTR1(b)     REG((b) + 0x24u)
#define ADC_SQR1(b)     REG((b) + 0x30u)
#define ADC_DR(b)       REG((b) + 0x40u)
#define ADC_CCR(c)      REG((c) + 0x08u)
#define TS_CAL1         (*(volatile uint16_t *)0x1FF1E820u)   /* 30 °C, VDDA 3,3 В */
#define TS_CAL2         (*(volatile uint16_t *)0x1FF1E840u)   /* 110 °C */
#define VREFINT_CAL     (*(volatile uint16_t *)0x1FF1E860u)   /* VDDA 3,3 В, 30 °C */
#define ACR_DEEPPWD     (1u << 29)
#define ACR_ADVREGEN    (1u << 28)
#define ACR_ADCAL       (1u << 31)
#define ACR_ADCALLIN    (1u << 16)
#define ACR_ADSTART     (1u << 2)
#define ACR_ADEN        (1u << 0)
#define AISR_ADRDY      (1u << 0)
#define AISR_EOC        (1u << 2)
#define AISR_OVR        (1u << 4)
#define AISR_AWD1       (1u << 7)
#define ACFGR_OVRMOD    (1u << 12)
#define ACFGR_CONT      (1u << 13)
#define ACFGR_AWD1SGL   (1u << 22)
#define ACFGR_AWD1EN    (1u << 23)
#define ACFGR_AWD1CH(c) ((uint32_t)(c) << 26)
#define ACCR_VREFEN     (1u << 22)
#define ACCR_TSEN       (1u << 23)

/* --- барьеры и маски прерываний */
#define DSB()           __asm volatile ("dsb 0xF" ::: "memory")
#define ISB()           __asm volatile ("isb 0xF" ::: "memory")
#define WFI()           __asm volatile ("wfi")
static inline uint32_t irq_save(void)
{
    uint32_t p;
    __asm volatile ("mrs %0, primask\n cpsid i" : "=r"(p) :: "memory");
    return p;
}
static inline void irq_restore(uint32_t p) { __asm volatile ("msr primask, %0" :: "r"(p) : "memory"); }

#endif
