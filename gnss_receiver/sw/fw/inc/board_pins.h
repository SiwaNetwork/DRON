/* МГП-8: выводы МК STM32H743VIT6 (DD9) по схеме ШИВА.468157.001 Э3, лист 9.
 * Создан tools/gen_board.py из hw/kicad/09_mcu.kicad_sch — не править вручную;
 * сверка со схемой — make -C sw/fw board-check. PIN(порт, n): порт A = 0 … K = 10. */
#ifndef BOARD_PINS_H
#define BOARD_PINS_H

#define PIN(port, n)   ((PORT_##port << 4) | (n))
#define PIN_PORT(p)    ((p) >> 4)
#define PIN_NUM(p)     ((p) & 15)
enum { PORT_A, PORT_B, PORT_C, PORT_D, PORT_E, PORT_F, PORT_G, PORT_H, PORT_I, PORT_J, PORT_K };

#define PIN_DBG_TX         PIN(A,  0)   /* вывод 22 */
#define PIN_DBG_RX         PIN(A,  1)   /* вывод 23 */
#define PIN_PPS_MCU        PIN(A,  2)   /* вывод 24 */
#define PIN_EXTINT_MCU     PIN(A,  3)   /* вывод 25 */
#define PIN_GPS_TX         PIN(A,  9)   /* вывод 68 */
#define PIN_GPS_RX         PIN(A, 10)   /* вывод 69 */
#define PIN_SWDIO          PIN(A, 13)   /* вывод 72 */
#define PIN_SWCLK          PIN(A, 14)   /* вывод 76 */
#define PIN_MCU_TDI        PIN(A, 15)   /* вывод 77 */
#define PIN_FX3_RESETN     PIN(B,  2)   /* вывод 36 */
#define PIN_SWO            PIN(B,  3)   /* вывод 89 */
#define PIN_FMC_NL         PIN(B,  7)   /* вывод 93 */
#define PIN_CAN_RX         PIN(B,  8)   /* вывод 95 */
#define PIN_CAN_TX         PIN(B,  9)   /* вывод 96 */
#define PIN_CAN_STBY       PIN(B, 12)   /* вывод 51 */
#define PIN_SD_CD          PIN(B, 13)   /* вывод 52 */
#define PIN_LED_ANT_K      PIN(B, 14)   /* вывод 53 */
#define PIN_ANT_IMON       PIN(C,  0)   /* вывод 15 */
#define PIN_V5_MON         PIN(C,  1)   /* вывод 16 */
#define PIN_V3V3_MON       PIN(C,  4)   /* вывод 32 */
#define PIN_V1V1_MON       PIN(C,  5)   /* вывод 33 */
#define PIN_SD_D0          PIN(C,  8)   /* вывод 65 */
#define PIN_SD_D1          PIN(C,  9)   /* вывод 66 */
#define PIN_SD_D2          PIN(C, 10)   /* вывод 78 */
#define PIN_SD_D3          PIN(C, 11)   /* вывод 79 */
#define PIN_SD_CLK_R       PIN(C, 12)   /* вывод 80 */
#define PIN_LED_FIX_K      PIN(C, 13)   /* вывод 7 */
#define PIN_OSC32_IN       PIN(C, 14)   /* вывод 8 */
#define PIN_OSC32_OUT      PIN(C, 15)   /* вывод 9 */
#define PIN_FMC_DA2        PIN(D,  0)   /* вывод 81 */
#define PIN_FMC_DA3        PIN(D,  1)   /* вывод 82 */
#define PIN_SD_CMD         PIN(D,  2)   /* вывод 83 */
#define PIN_FMC_NOE        PIN(D,  4)   /* вывод 85 */
#define PIN_FMC_NWE        PIN(D,  5)   /* вывод 86 */
#define PIN_FMC_NWAIT      PIN(D,  6)   /* вывод 87 */
#define PIN_FMC_NE1        PIN(D,  7)   /* вывод 88 */
#define PIN_FMC_DA13       PIN(D,  8)   /* вывод 55 */
#define PIN_FMC_DA14       PIN(D,  9)   /* вывод 56 */
#define PIN_FMC_DA15       PIN(D, 10)   /* вывод 57 */
#define PIN_GPS_SCL        PIN(D, 12)   /* вывод 59 */
#define PIN_GPS_SDA        PIN(D, 13)   /* вывод 60 */
#define PIN_FMC_DA0        PIN(D, 14)   /* вывод 61 */
#define PIN_FMC_DA1        PIN(D, 15)   /* вывод 62 */
#define PIN_FPGA_PROGRAMN  PIN(E,  2)   /* вывод 1 */
#define PIN_FPGA_INITN     PIN(E,  3)   /* вывод 2 */
#define PIN_FPGA_DONE      PIN(E,  4)   /* вывод 3 */
#define PIN_FPGA_IRQ       PIN(E,  5)   /* вывод 4 */
#define PIN_ANT_EN         PIN(E,  6)   /* вывод 5 */
#define PIN_FMC_DA4        PIN(E,  7)   /* вывод 37 */
#define PIN_FMC_DA5        PIN(E,  8)   /* вывод 38 */
#define PIN_FMC_DA6        PIN(E,  9)   /* вывод 39 */
#define PIN_FMC_DA7        PIN(E, 10)   /* вывод 40 */
#define PIN_FMC_DA8        PIN(E, 11)   /* вывод 41 */
#define PIN_FMC_DA9        PIN(E, 12)   /* вывод 42 */
#define PIN_FMC_DA10       PIN(E, 13)   /* вывод 43 */
#define PIN_FMC_DA11       PIN(E, 14)   /* вывод 44 */
#define PIN_FMC_DA12       PIN(E, 15)   /* вывод 45 */
#define PIN_MCU_CLK24      PIN(H,  0)   /* вывод 12 */

#endif
