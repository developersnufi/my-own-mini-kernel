#include "keyboard.h"
#include "vga.h"

void kernel_main(void)
{
    terminal_initialize();
    terminal_writestring("System online!\n");
    terminal_writestring("Type on the keyboard:\n");

    for (;;) {
        keyboard_poll();
    }
}
