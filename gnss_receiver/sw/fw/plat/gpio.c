/* МГП-8: выводы GPIO (номер вывода — PIN(порт, n), inc/board_pins.h). Настройка — только при
 * инициализации (чтение-изменение-запись регистров порта); gpio_set — атомарно (BSRR). */
#include "plat.h"

static void port_on(int p)
{
    RCC_AHB4ENR |= 1u << p;
    (void)RCC_AHB4ENR;
}

static void field(volatile uint32_t *r, int n, int bits, uint32_t v)
{
    uint32_t m = (1u << bits) - 1u;
    *r = (*r & ~(m << bits * n)) | (v & m) << bits * n;
}

void gpio_set(int pin, int v) { GPIO_BSRR(PIN_PORT(pin)) = 1u << (PIN_NUM(pin) + (v ? 0 : 16)); }
int  gpio_get(int pin) { return (int)(GPIO_IDR(PIN_PORT(pin)) >> PIN_NUM(pin) & 1u); }

static void cfg(int pin, uint32_t mode, int od, int pull)
{
    int p = PIN_PORT(pin), n = PIN_NUM(pin);
    port_on(p);
    field(&GPIO_OTYPER(p), n, 1, (uint32_t)od);
    field(&GPIO_PUPDR(p), n, 2, (uint32_t)pull);
    field(&GPIO_MODER(p), n, 2, mode);
}

void gpio_out(int pin, int v) { port_on(PIN_PORT(pin)); gpio_set(pin, v); cfg(pin, 1, 0, PULL_NONE); }
void gpio_od(int pin, int v)  { port_on(PIN_PORT(pin)); gpio_set(pin, v); cfg(pin, 1, 1, PULL_UP); }
void gpio_in(int pin, int pull) { cfg(pin, 0, 0, pull); }
void gpio_an(int pin) { cfg(pin, 3, 0, PULL_NONE); }

void gpio_af(int pin, int af, int pull, int speed)
{
    int p = PIN_PORT(pin), n = PIN_NUM(pin);
    port_on(p);
    field(&GPIO_AFR(p, n >> 3), n & 7, 4, (uint32_t)af);
    field(&GPIO_OSPEEDR(p), n, 2, (uint32_t)speed);
    cfg(pin, 2, 0, pull);
}
