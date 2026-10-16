/* МГП-8: запуск ПО МК и загрузчика — таблица векторов, Reset_Handler (FPU, копирование .data и
 * .itcm, обнуление .bss во всех областях ОЗУ), обработчик отказов. Отказ (HardFault, MemManage,
 * BusFault, UsageFault, NMI, неожиданное прерывание) записывается в общую область загрузчика
 * (boot_shared_t) и завершается сбросом; ПО МК выводит запись при следующем запуске. */
#include "plat.h"

extern uint32_t _estack, _sidata, _sdata, _edata, _siitcm, _sitcm, _eitcm, _sbss, _ebss;
extern uint32_t _sbss_dtcm, _ebss_dtcm, _sbss_d2, _ebss_d2, _sbss_sram4, _ebss_sram4;
int main(void);

void Reset_Handler(void) __attribute__((noreturn));
void Fault_Handler(void);
void fault_record(const uint32_t *f) __attribute__((noreturn, used));
#define ALIAS __attribute__((weak, alias("Fault_Handler")))
void NMI_Handler(void) ALIAS;
void HardFault_Handler(void) ALIAS;
void MemManage_Handler(void) ALIAS;
void BusFault_Handler(void) ALIAS;
void UsageFault_Handler(void) ALIAS;
void SVC_Handler(void) ALIAS;
void DebugMon_Handler(void) ALIAS;
void PendSV_Handler(void) ALIAS;
void SysTick_Handler(void) ALIAS;
void ADC_IRQHandler(void) ALIAS;
void FDCAN1_IT0_IRQHandler(void) ALIAS;
void EXTI9_5_IRQHandler(void) ALIAS;
void USART1_IRQHandler(void) ALIAS;
void SDMMC1_IRQHandler(void) ALIAS;
void UART4_IRQHandler(void) ALIAS;

typedef void (*vec_t)(void);
#pragma GCC diagnostic push
#pragma GCC diagnostic ignored "-Woverride-init"
__attribute__((section(".isr_vector"), used))
const vec_t g_vectors[16 + NIRQ] = {
    [0]  = (vec_t)&_estack,
    [1]  = Reset_Handler,
    [2]  = NMI_Handler,
    [3]  = HardFault_Handler,
    [4]  = MemManage_Handler,
    [5]  = BusFault_Handler,
    [6]  = UsageFault_Handler,
    [11] = SVC_Handler,
    [12] = DebugMon_Handler,
    [14] = PendSV_Handler,
    [15] = SysTick_Handler,
    [16 ... 16 + NIRQ - 1] = Fault_Handler,
    [16 + IRQ_ADC1_2]     = ADC_IRQHandler,
    [16 + IRQ_FDCAN1_IT0] = FDCAN1_IT0_IRQHandler,
    [16 + IRQ_EXTI9_5]    = EXTI9_5_IRQHandler,
    [16 + IRQ_USART1]     = USART1_IRQHandler,
    [16 + IRQ_SDMMC1]     = SDMMC1_IRQHandler,
    [16 + IRQ_UART4]      = UART4_IRQHandler,
};
#pragma GCC diagnostic pop

/* кадр исключения — в стеке, активном до отказа; обработчик продолжает на вершине DTCM (выше
 * boot_shared_t), так как отказ мог быть вызван переполнением основного стека */
__attribute__((naked)) void Fault_Handler(void)
{
    __asm volatile (
        "tst   lr, #4\n"
        "ite   eq\n"
        "mrseq r0, msp\n"
        "mrsne r0, psp\n"
        "movw  r1, #0\n"
        "movt  r1, #0x2002\n"
        "msr   msp, r1\n"
        "b     fault_record\n");
}

void fault_record(const uint32_t *f)
{
    volatile boot_shared_t *s = boot_sh();
    uint32_t a = (uint32_t)(uintptr_t)f, ipsr;
    int ok = (a >= 0x20000000u && a <= 0x20020000u - 32u) || (a >= 0x24000000u && a <= 0x24080000u - 32u);
    __asm volatile ("mrs %0, ipsr" : "=r"(ipsr));
    s->ipsr = ipsr;
    s->cfsr = SCB_CFSR; s->hfsr = SCB_HFSR; s->mmfar = SCB_MMFAR; s->bfar = SCB_BFAR;
    s->pc = ok ? f[6] : 0; s->lr = ok ? f[5] : 0; s->psr = ok ? f[7] : 0;
    s->fault = FAULT_KEY;
    sys_reset();
}

/* циклы копирования не заменяются вызовами memcpy/memset: библиотека может обращаться к .data */
__attribute__((optimize("no-tree-loop-distribute-patterns")))
static void copy(uint32_t *src, uint32_t *d, uint32_t *e)
{
    while (d < e) *d++ = *src++;
}

__attribute__((optimize("no-tree-loop-distribute-patterns")))
static void zero(uint32_t *d, uint32_t *e)
{
    while (d < e) *d++ = 0;
}

void Reset_Handler(void)
{
    SCB_CPACR |= 0xFu << 20;                    /* FPU: CP10, CP11 — полный доступ */
    RCC_AHB2ENR |= AHB2_SRAM123;                /* SRAM1–3 (D2) */
    DSB(); ISB();
    copy(&_siitcm, &_sitcm, &_eitcm);
    copy(&_sidata, &_sdata, &_edata);
    zero(&_sbss, &_ebss);
    zero(&_sbss_dtcm, &_ebss_dtcm);
    zero(&_sbss_d2, &_ebss_d2);
    zero(&_sbss_sram4, &_ebss_sram4);
    SCB_VTOR = (uint32_t)(uintptr_t)g_vectors;
    DSB(); ISB();
    main();
    sys_reset();
}
