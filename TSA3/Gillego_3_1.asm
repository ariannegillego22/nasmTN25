
global _start

section .data
    inc_text db 'INC: FF + 1 = 0x'
    inc_text_len equ $ - inc_text
    dec_text db 'DEC: 00 - 1 = 0x'
    dec_text_len equ $ - dec_text
    newline db 10

section .bss
    inc_result resb 1
    dec_result resb 1
    hex_text   resb 2

section .text
_start:
    mov al, 0FFh
    inc al
    mov [inc_result], al

    mov al, 00h
    dec al
    mov [dec_result], al

    ; INC and DEC preserve the old Carry flag instead of recalculating it.
    ; A loop counter can change without losing an unrelated carry,
    ; but INC/DEC cannot be used to detect arithmetic overflow.

    mov ecx, inc_text
    mov edx, inc_text_len
    call print_string
    mov al, [inc_result]
    call byte_to_hex
    mov ecx, hex_text
    mov edx, 2
    call print_string

    mov ecx, newline
    mov edx, 1
    call print_string

    mov ecx, dec_text
    mov edx, dec_text_len
    call print_string
    mov al, [dec_result]
    call byte_to_hex
    mov ecx, hex_text
    mov edx, 2
    call print_string

    mov ecx, newline
    mov edx, 1
    call print_string

    mov eax, 1
    xor ebx, ebx
    int 80h

print_string:
    mov eax, 4
    mov ebx, 1
    int 80h
    ret

byte_to_hex:
    mov ah, al
    shr al, 4
    and al, 0Fh
    call nibble_to_ascii
    mov [hex_text], al

    mov al, ah
    and al, 0Fh
    call nibble_to_ascii
    mov [hex_text + 1], al
    ret

nibble_to_ascii:
    cmp al, 9
    jbe digit
    add al, 'A' - 10
    ret

digit:
    add al, '0'
    ret