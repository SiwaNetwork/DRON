/* МГП-8: АЦП — контроль питания, ток и защита антенны, температура МК.
 *
 * Такт АЦП — per_ck (HSI 64 МГц) / 2 (PRESC), у рев. V — ещё /2 внутри АЦП: 16 МГц (рев. V) или
 * 32 МГц (рев. Y); разрядность 16.
 *   ADC1 (по запросу, выборка 810,5 такта): V5_MON PC1 (INP11, делитель ×2), V3V3_MON PC4 (INP4,
 *        ×2), V1V1_MON PC5 (INP8);
 *   ADC2 (непрерывно, 64,5 + 8,5 такта ≈ 4,6 мкс у рев. V): ANT_IMON PC0 (INP10) — INA181 ×20 на
 *        шунте 1 Ом, 20 мВ/мА. Аналоговый сторожевой таймер AWD1: порог 100 мА (2,0 В), прерывание
 *        (приоритет 0x00) снимает ANT_EN за время одного преобразования; повтор через 10 с;
 *   ADC3 (по запросу): датчик температуры (INP18), VREFINT (INP19) — напряжение VDDA.
 * Состояние антенны: ток < 5 мА — обрыв (антенна не подключена), ≥ 100 мА — КЗ. */
#include "plat.h"

#define ACR_RS      0x8000003Fu                 /* биты CR, запись 1 в которые запускает действие */
#define ANT_OPEN_MA 5.0f
#define ANT_MAX_MA  100.0f
#define ANT_RETRY   10000u

static struct {
    volatile int st;
    volatile uint32_t t_off, n_short;
} ant;

static void cr_set(uint32_t b, uint32_t bits) { ADC_CR(b) = (ADC_CR(b) & ~ACR_RS) | bits; }

static int wait_flag(volatile uint32_t *r, uint32_t m, uint32_t v, uint32_t ms)
{
    uint32_t t0 = sys_ms;
    while ((*r & m) != v)
        if (sys_ms - t0 > ms) return -1;
    return 0;
}

static void adc_on(uint32_t b, uint32_t pcsel)
{
    uint32_t boost = sys_rev >= 0x2000u ? 2u << 8 : 1u << 8;
    ADC_CR(b) = ACR_ADVREGEN | boost;           /* выход из DEEPPWD, стабилизатор */
    delay_us(20);
    cr_set(b, ACR_ADCALLIN | ACR_ADCAL);        /* калибровка смещения и линейности */
    wait_flag(&ADC_CR(b), ACR_ADCAL, 0, 100);
    ADC_ISR(b) = AISR_ADRDY;
    cr_set(b, ACR_ADEN);
    wait_flag(&ADC_ISR(b), AISR_ADRDY, AISR_ADRDY, 10);
    ADC_PCSEL(b) = pcsel;
}

static void smp(uint32_t b, int ch, uint32_t code)
{
    volatile uint32_t *r = &ADC_SMPR(b, ch / 10);
    int sh = 3 * (ch % 10);
    *r = (*r & ~(7u << sh)) | code << sh;
}

static uint32_t conv(uint32_t b, int ch)
{
    ADC_SQR1(b) = (uint32_t)ch << 6;            /* одно преобразование, SQ1 = ch */
    ADC_ISR(b) = AISR_EOC | AISR_OVR;
    cr_set(b, ACR_ADSTART);
    if (wait_flag(&ADC_ISR(b), AISR_EOC, AISR_EOC, 5)) return 0;
    return ADC_DR(b);
}

static float vdda_now(void)
{
    uint32_t d = conv(ADC3_BASE, 19);
    return d ? 3.3f * (float)VREFINT_CAL / (float)d : 3.3f;
}

void adc_init(void)
{
    RCC_D3CCIPR = (RCC_D3CCIPR & ~(3u << 16)) | 2u << 16;     /* ADCSEL = per_ck */
    RCC_AHB1ENR |= AHB1_ADC12;
    RCC_AHB4ENR |= AHB4_ADC3;
    (void)RCC_AHB4ENR;
    gpio_an(PIN_ANT_IMON); gpio_an(PIN_V5_MON); gpio_an(PIN_V3V3_MON); gpio_an(PIN_V1V1_MON);
    ADC_CCR(ADC12_COMMON) = 1u << 18;           /* асинхронный такт, PRESC /2 */
    ADC_CCR(ADC3_COMMON) = 1u << 18 | ACCR_VREFEN | ACCR_TSEN;
    adc_on(ADC1_BASE, 1u << 4 | 1u << 8 | 1u << 11);
    adc_on(ADC2_BASE, 1u << 10);
    adc_on(ADC3_BASE, 1u << 18 | 1u << 19);
    smp(ADC1_BASE, 4, 7); smp(ADC1_BASE, 8, 7); smp(ADC1_BASE, 11, 7);
    smp(ADC3_BASE, 18, 7); smp(ADC3_BASE, 19, 7);
    smp(ADC2_BASE, 10, 5);
    /* ADC2: непрерывное преобразование INP10, AWD1 по порогу тока */
    float vdda = vdda_now();
    ADC_CFGR(ADC2_BASE) = ACFGR_CONT | ACFGR_OVRMOD | ACFGR_AWD1SGL | ACFGR_AWD1EN | ACFGR_AWD1CH(10);
    ADC_SQR1(ADC2_BASE) = 10u << 6;
    ADC_LTR1(ADC2_BASE) = 0;
    ADC_HTR1(ADC2_BASE) = (uint32_t)(ANT_MAX_MA * 0.02f / vdda * 65535.0f);
    ADC_IER(ADC2_BASE) = 0;
    ADC_ISR(ADC2_BASE) = 0x7FFu;
    cr_set(ADC2_BASE, ACR_ADSTART);
    irq_prio(IRQ_ADC1_2, 0x00u);
    irq_on(IRQ_ADC1_2);
    gpio_out(PIN_ANT_EN, 0);
    ant.st = ANT_OFF;
}

void ADC_IRQHandler(void)
{
    if (ADC_ISR(ADC2_BASE) & AISR_AWD1) {
        gpio_set(PIN_ANT_EN, 0);
        ADC_IER(ADC2_BASE) = 0;
        ADC_ISR(ADC2_BASE) = AISR_AWD1;
        ant.st = ANT_SHORT;
        ant.t_off = sys_ms;
        ant.n_short++;
    }
}

/* включение: выдержка 2 мс на заряд ёмкости линии до разрешения защиты */
void ant_set(int on)
{
    if (!on) {
        ADC_IER(ADC2_BASE) = 0;
        gpio_set(PIN_ANT_EN, 0);
        ant.st = ANT_OFF;
        return;
    }
    gpio_set(PIN_ANT_EN, 1);
    delay_us(2000);
    uint32_t p = irq_save();
    ant.st = ANT_OK;
    ADC_ISR(ADC2_BASE) = AISR_AWD1;
    ADC_IER(ADC2_BASE) = AISR_AWD1;
    irq_restore(p);
}

int ant_poll(float ma)
{
    if (ant.st == ANT_SHORT) {
        if (sys_ms - ant.t_off >= ANT_RETRY) ant_set(1);
        return ant.st;
    }
    uint32_t p = irq_save();
    if (ant.st != ANT_OFF && ant.st != ANT_SHORT) ant.st = ma < ANT_OPEN_MA ? ANT_OPEN : ANT_OK;
    irq_restore(p);
    return ant.st;
}

void adc_read(adc_tm_t *t)
{
    float vdda = vdda_now(), k = vdda / 65535.0f;
    uint32_t d = conv(ADC3_BASE, 18);
    t->vdda = vdda;
    t->t_mcu = 80.0f / (float)(TS_CAL2 - TS_CAL1) * ((float)d * vdda / 3.3f - (float)TS_CAL1) + 30.0f;
    t->v5 = (float)conv(ADC1_BASE, 11) * k * 2.0f;
    t->v3v3 = (float)conv(ADC1_BASE, 4) * k * 2.0f;
    t->v1v1 = (float)conv(ADC1_BASE, 8) * k;
    t->ant_ma = (float)(ADC_DR(ADC2_BASE) & 0xFFFFu) * k * 50.0f;
    t->ant = ant.st;
    t->n_short = ant.n_short;
}
