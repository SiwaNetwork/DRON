/* МГП-8: планировщик фоновых задач — опрос по периоду (мс, 0 — на каждом проходе), сброс
 * сторожевого таймера на каждом проходе, WFI при отсутствии работы (пробуждение — любое
 * прерывание, не реже SysTick 1 мс). */
#include "plat.h"

#define SCHED_N 8

static struct { int (*fn)(void); uint32_t per, next; } T[SCHED_N];
static int nt;

void sched_add(int (*fn)(void), uint32_t period_ms)
{
    if (nt >= SCHED_N) return;
    T[nt].fn = fn; T[nt].per = period_ms; T[nt].next = sys_ms;
    nt++;
}

void sched_run(void)
{
    for (;;) {
        int work = 0;
        for (int i = 0; i < nt; i++) {
            uint32_t now = sys_ms;
            if ((int32_t)(now - T[i].next) < 0) continue;
            T[i].next += T[i].per;
            if ((int32_t)(now - T[i].next) >= 0) T[i].next = now + T[i].per;   /* пропуск без догонки */
            work |= T[i].fn();
        }
        wdg_kick();
        if (!work) WFI();
    }
}
