/* МГП-8: размещение секций (общее для ПО МК и загрузчика; области — ld/mgp8.ld, ld/boot.ld).
 *
 *   FLASH  таблица векторов, заголовок образа (смещение 0x400), код и константы, образы
 *          .itcm и .data;
 *   DTCM   стек (внизу: переполнение — отказ шины ниже 0x20000000), .bss.dtcm (снимки);
 *          последние 256 байт — общая область загрузчика (boot_shared_t, вне областей);
 *   ITCM   .itcm — код, критичный ко времени (копируется при запуске);
 *   AXI    .data, .bss, куча (newlib: sprintf с плавающей точкой);
 *   D2     .bss.d2 (состояние приёмника); SRAM4 — .bss.sram4.
 * Makefile дописывает этот файл к области (ld/mgp8.ld, ld/boot.ld) в build/mcu/*.ld.
 * Секции .bss.dtcm/.bss.d2/.bss.sram4 перечислены раньше .bss — шаблон .bss.* их не забирает. */
ENTRY(Reset_Handler)

_stack_size = 0x7E00;
_heap_size  = 16K;

SECTIONS
{
    .isr_vector : {
        KEEP(*(.isr_vector))
        . = 0x400;
        KEEP(*(.app_hdr))
        . = ALIGN(4);
    } >FLASH

    .text : {
        *(.text .text.*)
        *(.glue_7) *(.glue_7t) *(.vfp11_veneer) *(.v4_bx)
        KEEP(*(.init))
        KEEP(*(.fini))
        . = ALIGN(4);
    } >FLASH

    .rodata : {
        *(.rodata .rodata.*)
        . = ALIGN(4);
    } >FLASH

    .ARM.extab : { *(.ARM.extab* .gnu.linkonce.armextab.*) } >FLASH
    .ARM.exidx : {
        __exidx_start = .;
        *(.ARM.exidx* .gnu.linkonce.armexidx.*)
        __exidx_end = .;
    } >FLASH

    .preinit_array : {
        PROVIDE_HIDDEN(__preinit_array_start = .);
        KEEP(*(.preinit_array*))
        PROVIDE_HIDDEN(__preinit_array_end = .);
    } >FLASH
    .init_array : {
        PROVIDE_HIDDEN(__init_array_start = .);
        KEEP(*(SORT(.init_array.*)))
        KEEP(*(.init_array*))
        PROVIDE_HIDDEN(__init_array_end = .);
    } >FLASH
    .fini_array : {
        PROVIDE_HIDDEN(__fini_array_start = .);
        KEEP(*(SORT(.fini_array.*)))
        KEEP(*(.fini_array*))
        PROVIDE_HIDDEN(__fini_array_end = .);
    } >FLASH

    .stack (NOLOAD) : {
        . = ALIGN(8);
        . += _stack_size;
        . = ALIGN(8);
        _estack = .;
    } >DTCM

    .bss_dtcm (NOLOAD) : ALIGN(32) {
        _sbss_dtcm = .;
        *(.bss.dtcm .bss.dtcm.*)
        . = ALIGN(4);
        _ebss_dtcm = .;
    } >DTCM

    .itcm : ALIGN(4) {
        _sitcm = .;
        *(.itcm .itcm.*)
        . = ALIGN(4);
        _eitcm = .;
    } >ITCM AT>FLASH
    _siitcm = LOADADDR(.itcm);

    .data : ALIGN(4) {
        _sdata = .;
        *(.data .data.*)
        . = ALIGN(4);
        _edata = .;
    } >AXI AT>FLASH
    _sidata = LOADADDR(.data);

    .bss_d2 (NOLOAD) : ALIGN(32) {
        _sbss_d2 = .;
        *(.bss.d2 .bss.d2.*)
        . = ALIGN(4);
        _ebss_d2 = .;
    } >D2

    .bss_sram4 (NOLOAD) : ALIGN(32) {
        _sbss_sram4 = .;
        *(.bss.sram4 .bss.sram4.*)
        . = ALIGN(4);
        _ebss_sram4 = .;
    } >SRAM4

    .bss (NOLOAD) : ALIGN(4) {
        _sbss = .;
        *(.bss .bss.* COMMON)
        . = ALIGN(4);
        _ebss = .;
    } >AXI

    .heap (NOLOAD) : ALIGN(8) {
        _heap_start = .;
        . += _heap_size;
        _heap_end = .;
    } >AXI

    .ARM.attributes 0 : { *(.ARM.attributes) }
}
