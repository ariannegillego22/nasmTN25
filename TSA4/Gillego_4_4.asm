global _start

section .data
    digit1 db '7'
    digit2 db '5'

    equation_msg db '7 + 5 = '
    equation_msg_len equ $ - equation_msg
    newline db 10

section .bss
    tens_digit resb 1
    ones_digit resb 1

section .text
_start:
    xor eax, eax              ; Clear EAX so AH starts at zero.
    mov al, [digit1]
    sub al, 30h               ; Change ASCII '7' into numeric 7.

    mov bl, [digit2]
    sub bl, 30h               ; Change ASCII '5' into numeric 5.

    add al, bl                ; AL is now 12 decimal, or 0Ch.
    aaa                       ; Adjust AL and AH into valid unpacked BCD digits.
                              ; AAA is needed because raw 0Ch is not the ASCII text "12".

    add ah, '0'               ; Convert the tens digit in AH to ASCII.
    mov [tens_digit], ah

    add al, '0'               ; Convert the ones digit in AL to ASCII.
    mov [ones_digit], al

    mov ecx, equation_msg
    mov edx, equation_msg_len
    call print_string

    mov ecx, tens_digit
    mov edx, 1
    call print_string

    mov ecx, ones_digit
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