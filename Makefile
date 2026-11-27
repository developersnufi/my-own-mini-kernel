NASM ?= nasm
CC ?= gcc
LD ?= ld
GRUB_MKRESCUE ?= grub-mkrescue
QEMU ?= qemu-system-i386

BUILD_DIR := build
ISO_DIR := iso
KERNEL := $(BUILD_DIR)/kernel.bin
ISO := myos.iso
KERNEL_OBJECTS := $(BUILD_DIR)/kernel.o $(BUILD_DIR)/vga.o $(BUILD_DIR)/keyboard.o
CFLAGS := -m32 -ffreestanding -fno-stack-protector -fno-pie -fno-pic -fno-asynchronous-unwind-tables -fno-unwind-tables -O2 -Wall -Wextra

.PHONY: all clean run

all: $(ISO)

$(BUILD_DIR):
	mkdir -p $@

$(BUILD_DIR)/boot.o: boot.asm | $(BUILD_DIR)
	$(NASM) -f elf32 $< -o $@

$(BUILD_DIR)/%.o: %.c | $(BUILD_DIR)
	$(CC) $(CFLAGS) -c $< -o $@

$(BUILD_DIR)/kernel.o $(BUILD_DIR)/keyboard.o: keyboard.h vga.h
$(BUILD_DIR)/keyboard.o: io.h
$(BUILD_DIR)/kernel.o: vga.h
$(BUILD_DIR)/vga.o: io.h vga.h

$(KERNEL): $(BUILD_DIR)/boot.o $(KERNEL_OBJECTS) linker.ld
	$(LD) -m elf_i386 -T linker.ld -nostdlib -o $@ $(BUILD_DIR)/boot.o $(KERNEL_OBJECTS)
	cp $@ $(ISO_DIR)/boot/kernel.bin

$(ISO): $(KERNEL) $(ISO_DIR)/boot/grub/grub.cfg
	$(GRUB_MKRESCUE) -o $@ $(ISO_DIR)

run: $(ISO)
	$(QEMU) -cdrom $(ISO)

clean:
	rm -rf $(BUILD_DIR) $(ISO_DIR)/boot/kernel.bin $(ISO)
