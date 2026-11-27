#include <stdint.h>

#include "vga.h"

#define VGA_WIDTH 80
#define VGA_HEIGHT 25

static unsigned int terminal_row;
static unsigned int terminal_column;
static uint8_t terminal_color;
static volatile uint16_t *const terminal_buffer =
    (volatile uint16_t *)0xB8000;

static uint16_t terminal_entry(char character)
{
    return (uint16_t)character | ((uint16_t)terminal_color << 8);
}

static void terminal_scroll(void)
{
    for (unsigned int row = 1; row < VGA_HEIGHT; row++) {
        for (unsigned int column = 0; column < VGA_WIDTH; column++) {
            terminal_buffer[(row - 1) * VGA_WIDTH + column] =
                terminal_buffer[row * VGA_WIDTH + column];
        }
    }

    for (unsigned int column = 0; column < VGA_WIDTH; column++) {
        terminal_buffer[(VGA_HEIGHT - 1) * VGA_WIDTH + column] =
            terminal_entry(' ');
    }

    terminal_row = VGA_HEIGHT - 1;
}

void terminal_initialize(void)
{
    terminal_row = 0;
    terminal_column = 0;
    terminal_color = 0x0F;

    for (unsigned int index = 0; index < VGA_WIDTH * VGA_HEIGHT; index++) {
        terminal_buffer[index] = terminal_entry(' ');
    }
}

void terminal_putchar(char character)
{
    if (character == '\n') {
        terminal_column = 0;
        terminal_row++;
    } else if (character == '\b') {
        if (terminal_column == 0) {
            return;
        }

        terminal_column--;
        terminal_buffer[terminal_row * VGA_WIDTH + terminal_column] =
            terminal_entry(' ');
        return;
    } else {
        terminal_buffer[terminal_row * VGA_WIDTH + terminal_column] =
            terminal_entry(character);
        terminal_column++;

        if (terminal_column == VGA_WIDTH) {
            terminal_column = 0;
            terminal_row++;
        }
    }

    if (terminal_row == VGA_HEIGHT) {
        terminal_scroll();
    }
}

void terminal_writestring(const char *string)
{
    for (unsigned int index = 0; string[index] != '\0'; index++) {
        terminal_putchar(string[index]);
    }
}
