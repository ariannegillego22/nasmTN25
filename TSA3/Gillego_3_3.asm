global _start

section .data
    mul_text db 'Unsigned MUL: 20 x 15 = 300', 10
    mul_len equ $ - mul_text

    imul_text db 'Signed IMUL: -6 x 4 = -24', 10
    imul_len equ $ - imul_text

    div_text db 'Unsigned DIV: 47 / 6 = quotient '
    div_len equ $ - div_text

    rem_text db ', remainder '
    rem_len equ $ - rem_text

    newline db 10

section .bss
    unsigned_product resw 1
    signed_product   resw 1
    quotient         resb 1
    remainder        resb 1
    digit_text       resb 1

section .text
_start:
    mov al, 20
    mov bl, 15
    mul bl
    ; For byte MUL, the 16-bit product is stored in AX.
    mov [unsigned_product], ax

    mov al, -6
    mov bl, 4
    imul bl
    ; For byte IMUL, the signed 16-bit product is also stored in AX.
    ; MUL would treat -6 as unsigned 250, so it would not produce -24.
    mov [signed_product], ax

    mov ax, 47
    mov bl, 6
    div bl
    ; For byte DIV, AX is the dividend, AL is the quotient, and AH is the remainder.
    mov [quotient], al
    mov [remainder], ah

    mov ecx, mul_text
    mov edx, mul_len
    call print_string

    mov ecx, imul_text
    mov edx, imul_len
    call print_string

    mov ecx, div_text
    mov edx, div_len
    call print_string

    mov al, [quotient]
    add al, '0'
    mov [digit_text], al
    mov ecx, digit_text
    mov edx, 1
    call print_string

    mov ecx, rem_text
    mov edx, rem_len
    call print_string

    mov al, [remainder]
    add al, '0'
    mov [digit_text], al
    mov ecx, digit_text
    mov edx, 1
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