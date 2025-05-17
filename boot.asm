[BITS 16]
[ORG 7c00h]
                    
start:
    cli
    xor ax, ax
    mov ds, ax
    mov es, ax
                    
    mov ax, 0x03
    int 0x10
  
    mov ah, 0x02   
    mov al, 3      
    mov ch, 0      
    mov dh, 0      
    mov cl, 2      
    mov bx, 0x500  
    int 0x13       
                    
    jc disk_error  
                    
    jmp 0x500          
                    
disk_error:
    mov si, error_message
    mov di, 0xB800
    call print_string
    jmp $             
                    
print_string:
    mov ah, 0x0E
.print_char:
    lodsb
    or al, al
    jz .done
    int 0x10
    jmp .print_char
.done:
    ret
                    
error_message db "fatal: Disk read error.", 13, 10, 0
                    
times 510 - ($ - $$) db 0
dw 0xAA55

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
;
