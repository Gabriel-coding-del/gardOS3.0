#!/bin/bash

# Assemble boot and kernel (kernel.asm includes otter.asm)
nasm -f bin boot.asm -o boot.bin
nasm -f bin kernel.asm -o kernel.bin

# Create blank 16-sector disk image (512 bytes * 16)
dd if=/dev/zero of=gardOS.img bs=512 count=16

# Write boot and kernel binaries into OS.img
dd if=boot.bin of=gardOS.img conv=notrunc
dd if=kernel.bin of=gardOS.img bs=512 seek=1 conv=notrunc

# Run in QEMU
qemu-system-i386 -fda gardOS.img

#!/bin/bash
# ============================================================================
#  gardOS Arcane Edition - GPLv3 License Notice
# ============================================================================
#
#  Copyright (C) 2025 Gabriel Sîrbu
#
#  This program is free software: you can redistribute it and/or modify
#  it under the terms of the GNU General Public License as published by
#  the Free Software Foundation, either version 3 of the License, or
#  (at your option) any later version.
#
#  This program is distributed in the hope that it will be useful,
#  but WITHOUT ANY WARRANTY; without even the implied warranty of
#  MERCHANTABILITY or FITNESS FOR A PARTICULAR PURPOSE. See the
#  GNU General Public License for more details.
#
#  You should have received a copy of the GNU General Public License
#  along with this program. If not, see <https://www.gnu.org/licenses/>.
#
# ============================================================================
