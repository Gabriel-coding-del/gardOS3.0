[BITS 16]
[ORG 500h]

start:
    mov ax, 0x03
    int 0x10

    mov si, hello_msg
    call print_string

    mov si, about_msg
    call print_string

    call shell

hang:
    jmp hang

print_string:
    mov ah, 0x0E
    
.print_char:
    lodsb
    cmp al, 0
    je .done
    int 0x10
    jmp .print_char
    
.done:
    ret

shell:
    mov si, prompt
    call print_string

    call read_command
    call print_newline

    call execute_command
    jmp shell

print_newline:
    mov ah, 0x0E
    mov al, 0x0D
    int 0x10
    mov al, 0x0A
    int 0x10
    ret

read_command:
    mov di, command_buffer
    xor cx, cx
    
.read_loop:
    mov ah, 0x00
    int 0x16
    cmp al, 0x0D
    je .done_read
    cmp al, 0x08
    je .handle_backspace
    cmp cx, 255
    jge .done_read
    stosb
    mov ah, 0x0E
    mov bl, 0x1F
    int 0x10
    inc cx
    jmp .read_loop

.handle_backspace:
    cmp di, command_buffer
    je .read_loop
    dec di
    dec cx
    mov ah, 0x0E
    mov al, 0x08
    int 0x10
    mov al, ' '
    int 0x10
    mov al, 0x08
    int 0x10
    jmp .read_loop

.done_read:
    mov byte [di], 0
    ret

execute_command:
    mov si, command_buffer
    mov di, help_str
    call compare_strings
    je do_help

    mov si, command_buffer
    mov di, about_str
    call compare_strings
    je do_about

    mov si, command_buffer
    mov di, cls_str
    call compare_strings
    je do_cls
    
    mov si, command_buffer
    mov di, date_str
    call compare_strings
    je print_date
    
    mov si, command_buffer
    mov di, time_str
    call compare_strings
    je print_time

    mov si, command_buffer
    mov di, easterEgg_str
    call compare_strings
    je easter_egg

    call unknown_command
    ret

compare_strings:
    xor cx, cx
    
.next_char:
    lodsb
    cmp al, [di]
    jne .not_equal
    cmp al, 0
    je .equal
    inc di
    jmp .next_char
    
.not_equal:
    ret
    
.equal:
    ret

easter_egg:
	mov si, easterEgg_resp
	call print_string
	ret

do_help:
    mov si, help_message
    call print_string
    ret

do_about:
	mov si, about_msg
	call print_string
	ret

do_cls:
    call clear_screen
    ret

unknown_command:
    mov si, unknown_msg
    call print_string
    call print_newline
    ret

clear_screen:
    mov ax, 0x03
    int 0x10
    ret
    
print_date:
    mov si, date_msg
    call print_string
    
    pusha
    mov ah, 0x04
    int 0x1a

    mov ah, 0x0e

    mov al, dl
    shr al, 4
    add al, '0'
    int 0x10
    mov al, dl
    and al, 0x0F
    add al, '0'
    int 0x10

    mov al, '.'
    int 0x10

    mov al, dh
    shr al, 4
    add al, '0'
    int 0x10
    mov al, dh
    and al, 0x0F
    add al, '0'
    int 0x10

    mov al, '.'
    int 0x10

    mov al, cl
    shr al, 4
    add al, '0'
    int 0x10
    mov al, cl
    and al, 0x0F
    add al, '0'
    int 0x10
    
    mov si, mt
    call print_string
    
    popa
    ret
    
date_msg db 'the date: ', 0

print_time:
    mov si, time_msg
    call print_string
    
    pusha
    mov ah, 0x02
    int 0x1a

    mov ah, 0x0e

    mov al, ch
    shr al, 4
    add al, '0'
    int 0x10
    mov al, ch
    and al, 0x0F
    add al, '0'
    int 0x10

    mov al, ':'
    int 0x10

    mov al, cl
    shr al, 4
    add al, '0'
    int 0x10
    mov al, cl
    and al, 0x0F
    add al, '0'
    int 0x10

    mov al, ':'
    int 0x10

    mov al, dh
    shr al, 4
    add al, '0'
    int 0x10
    mov al, dh
    and al, 0x0F
    add al, '0'
    int 0x10
    
    mov si, mt
    call print_string
    
    popa
    ret
    
time_msg db 'the time: ', 0

hello_msg db '______------------=================gardOS 3.0=================------------______', 13, 10, 0
help_str db 'help', 0
cls_str db 'clear', 0
easterEgg_str db '2012', 0
easterEgg_resp db 'mamaliga cu carnat, hailalalalalalala', 13, 10
			   db 'si cu castraveti murati..hailalalalalala', 13, 10, 0
date_str db 'date', 0
time_str db 'time', 0
about_str db 'about', 0
about_msg db '+-=-=-=-=-=-=-=-=-=-=-=-=+', 13, 10
		  db '|          about         |', 13, 10
		  db '+=-=-=-=-=-=-=-=-=-=-=-=-+', 13, 10
		  db '|name: gardOS 3.0        |', 13, 10
		  db '|codename: arcane edition|', 13, 10
		  db '|creator: Gabriel Sirbu  |', 13, 10
		  db '|gabriel sirbu (c) 2025  |', 13, 10
		  db '| all right reserved     |', 13, 10
		  db '+-=-=-=-=-=-=-=-=-=-=-=-=+'
mt db 13, 10, 0
help_message db '+-=-=-=-=-=-=-=-=-=-=-=-=-=-+', 13, 10 ;help clear date time
             db '|     available commands    |', 13, 10
             db '+=-=-=-=-=-=-=-=-=-=-=-=-=-=+', 13, 10
             db '|1. invoke help for help    |', 13, 10
             db '|2. invoke clear to clear   |', 13, 10
             db '|3. invoke date to show date|', 13, 10
             db '|4. invoke time to show time|', 13, 10
             db '|5. invoke about to get info|', 13, 10
             db '+-=-=-=-=-=-=-=-=-=-=-=-=-=-+', 13, 10, 0
prompt db 'gardOS ArcaneGate waits your invokation > ', 0
command_buffer db 25 dup(0)

unknown_msg db ' Doesent exists such thing in the dictionary - check the spelling', 0

; ============================================================================
;  gardOS Arcane Edition - GPLv3 License Notice
; ============================================================================
;
;  Copyright (C) 2025 Gabriel Sîrbu
;
;  This program is free software: you can redistribute it and/or modify
;  it under the terms of the GNU General Public License as published by
;  the Free Software Foundation, either version 3 of the License, or
;  (at your option) any later version.
;
;  This program is distributed in the hope that it will be useful,
;  but WITHOUT ANY WARRANTY; without even the implied warranty of
;  MERCHANTABILITY or FITNESS FOR A PARTICULAR PURPOSE. See the
;  GNU General Public License for more details.
;
;  You should have received a copy of the GNU General Public License
;  along with this program. If not, see <https://www.gnu.org/licenses/>.
;
; ============================================================================
