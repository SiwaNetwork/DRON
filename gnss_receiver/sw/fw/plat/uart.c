/* МГП-8: UART — USART1 (порт GPS, PA9/PA10, AF7) и UART4 (отладочный, PA0/PA1, AF8); 8N1,
 * кольцевые буферы приёма 512 и передачи 4096 байт, прерывания (приоритет 0x10).
 * uart_write помещает сообщение в буфер целиком под BASEPRI 0x10 (сообщения разных уровней
 * выполнения не перемешиваются; защита антенны, приоритет 0x00, не задерживается). При
 * переполнении остаток сообщения отбрасывается (uart_st.tx_drop). */
#include "plat.h"

#define RXN 512u
#define TXN 4096u
#define BARRIER() __asm volatile ("" ::: "memory")

typedef struct {
    uint32_t base;
    volatile uint32_t rh, rt, th, tt;           /* голова — запись, хвост — чтение */
    uint8_t rx[RXN], tx[TXN];
} uart_t;

static uart_t U[UART_N];                        /* в .bss: base задаёт uart_init */
uart_stat_t uart_st[UART_N];

void uart_init(int u, uint32_t baud)
{
    uart_t *s = &U[u];
    uint32_t b = s->base = u == UART_GPS ? USART1_BASE : UART4_BASE;
    if (u == UART_GPS) {
        RCC_APB2ENR |= APB2_USART1;
        (void)RCC_APB2ENR;
        gpio_af(PIN_GPS_TX, 7, PULL_NONE, 1);
        gpio_af(PIN_GPS_RX, 7, PULL_UP, 1);
    } else {
        RCC_APB1LENR |= APB1L_UART4;
        (void)RCC_APB1LENR;
        gpio_af(PIN_DBG_TX, 8, PULL_NONE, 1);
        gpio_af(PIN_DBG_RX, 8, PULL_UP, 1);
    }
    irq_off(u == UART_GPS ? IRQ_USART1 : IRQ_UART4);
    U_CR1(b) = 0;
    s->rh = s->rt = s->th = s->tt = 0;
    U_BRR(b) = (pclk_hz + baud / 2u) / baud;    /* передискретизация 16, ядро — PCLK1/PCLK2 */
    U_CR2(b) = 0;
    U_CR3(b) = 0;
    U_ICR(b) = 0xFFFFFFFFu;
    U_CR1(b) = UCR1_UE | UCR1_RE | UCR1_TE | UCR1_RXNEIE;
    irq_prio(u == UART_GPS ? IRQ_USART1 : IRQ_UART4, 0x10u);
    irq_on(u == UART_GPS ? IRQ_USART1 : IRQ_UART4);
}

static void isr(int u)
{
    uart_t *s = &U[u];
    uint32_t b = s->base, st = U_ISR(b);
    if (st & UISR_ERR) {
        U_ICR(b) = UISR_ERR;
        uart_st[u].err++;
    }
    if (st & UISR_RXNE) {
        uint8_t d = (uint8_t)U_RDR(b);
        uint32_t h = s->rh, nh = (h + 1u) % RXN;
        if (nh != s->rt) {
            s->rx[h] = d;
            BARRIER();
            s->rh = nh;
        } else {
            uart_st[u].rx_ovf++;
        }
    }
    if ((U_CR1(b) & UCR1_TXEIE) && (st & UISR_TXE)) {
        uint32_t t = s->tt;
        if (t != s->th) {
            U_TDR(b) = s->tx[t];
            s->tt = (t + 1u) % TXN;
        } else {
            U_CR1(b) &= ~UCR1_TXEIE;
        }
    }
}

void USART1_IRQHandler(void) { isr(UART_GPS); }
void UART4_IRQHandler(void) { isr(UART_DBG); }

int uart_write(int u, const void *p, int n)
{
    uart_t *s = &U[u];
    const uint8_t *d = p;
    int k = 0;
    if (!s->base) return 0;
    uint32_t o = basepri_raise(0x10u);
    uint32_t h = s->th, t = s->tt;
    for (; k < n; k++) {
        uint32_t nh = (h + 1u) % TXN;
        if (nh == t) break;
        s->tx[h] = d[k];
        h = nh;
    }
    if (k) {
        s->th = h;
        U_CR1(s->base) |= UCR1_TXEIE;
    }
    if (k < n) uart_st[u].tx_drop += (uint32_t)(n - k);
    basepri_set(o);
    return k;
}

int uart_read(int u, void *p, int n)
{
    uart_t *s = &U[u];
    uint8_t *d = p;
    int k = 0;
    uint32_t t = s->rt, h = s->rh;
    BARRIER();
    while (k < n && t != h) {
        d[k++] = s->rx[t];
        t = (t + 1u) % RXN;
    }
    BARRIER();
    s->rt = t;
    return k;
}

void uart_flush(int u)
{
    uart_t *s = &U[u];
    if (!s->base) return;
    uint32_t t0 = DWT_CYCCNT, lim = sys_hz / 2u;
    while ((s->th != s->tt || !(U_ISR(s->base) & UISR_TC)) && DWT_CYCCNT - t0 < lim) wdg_kick();
}

/* форматирование: %d %u %x %X %s %c %%, флаг 0, ширина; модификатор l пропускается (long = int) */
int fmt_v(char *b, int size, const char *f, va_list ap)
{
    int n = 0;
#define PUT(c) do { if (n < size - 1) b[n] = (char)(c); n++; } while (0)
    for (; *f; f++) {
        if (*f != '%') { PUT(*f); continue; }
        f++;
        int zero = 0, w = 0, neg = 0, k = 0;
        char t[12];
        const char *str = 0;
        if (*f == '0') { zero = 1; f++; }
        while (*f >= '0' && *f <= '9') w = w * 10 + (*f++ - '0');
        while (*f == 'l') f++;
        if (*f == 'd' || *f == 'u') {
            unsigned v;
            if (*f == 'd') { int x = va_arg(ap, int); neg = x < 0; v = neg ? 0u - (unsigned)x : (unsigned)x; }
            else v = va_arg(ap, unsigned);
            do { t[k++] = (char)('0' + v % 10u); v /= 10u; } while (v);
        } else if (*f == 'x' || *f == 'X') {
            const char *hx = *f == 'x' ? "0123456789abcdef" : "0123456789ABCDEF";
            unsigned v = va_arg(ap, unsigned);
            do { t[k++] = hx[v & 15u]; v >>= 4; } while (v);
        } else if (*f == 's') {
            str = va_arg(ap, const char *);
            if (!str) str = "(null)";
        } else if (*f == 'c') {
            t[k++] = (char)va_arg(ap, int);
        } else if (*f == '%') {
            t[k++] = '%';
        } else {
            if (!*f) break;
            PUT('%'); PUT(*f);
            continue;
        }
        if (str) {
            int l = 0;
            while (str[l]) l++;
            for (; w > l; w--) PUT(' ');
            while (*str) PUT(*str++);
            continue;
        }
        int len = k + neg;
        if (neg && zero) PUT('-');
        for (; w > len; w--) PUT(zero ? '0' : ' ');
        if (neg && !zero) PUT('-');
        while (k) PUT(t[--k]);
    }
    if (size > 0) b[n < size ? n : size - 1] = 0;
#undef PUT
    return n;
}

void dbg(const char *fmt, ...)
{
    char b[160];
    va_list ap;
    va_start(ap, fmt);
    int n = fmt_v(b, (int)sizeof(b), fmt, ap);
    va_end(ap);
    if (n > (int)sizeof(b) - 1) n = (int)sizeof(b) - 1;
    uart_write(UART_DBG, b, n);
}
