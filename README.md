# My Own Mini Kernel

A minimal 32-bit Multiboot kernel with a scrolling VGA text terminal and
polled PS/2 keyboard input. It accepts lowercase US-QWERTY letters, digits,
spaces, Enter, and Backspace.

## Requirements

On Ubuntu, install the build and test tools with:

```sh
sudo apt update
sudo apt install nasm gcc binutils grub-pc-bin grub-common xorriso qemu-system-x86
```

## Build and run

```sh
make
make run
```

The build produces `myos.iso`. To run it directly, use:

```sh
qemu-system-i386 -cdrom myos.iso
```

Run `make clean` to remove generated build and ISO files.
