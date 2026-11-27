ENTRY(start)

PHDRS
{
    text PT_LOAD FLAGS(5);
    data PT_LOAD FLAGS(6);
}

SECTIONS
{
    . = 1M;

    .text :
    {
        KEEP(*(.multiboot))
        *(.text*)
    } :text

    .rodata :
    {
        *(.rodata*)
    } :text

    .data :
    {
        *(.data*)
    } :data

    .bss :
    {
        *(COMMON)
        *(.bss*)
    } :data
}
