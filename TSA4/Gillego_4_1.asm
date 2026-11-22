global _start

section .data
    num1 db -12
    num2 db 25
    num3 db 8

    msg_num1 db 'The largest value is NUM1 (-12).', 10
    msg_num1_len equ $ - msg_num1

    msg_num2 db 'The largest value is NUM2 (25).', 10
    msg_num2_len equ $ - msg_num2

    msg_num3 db 'The largest value is NUM3 (8).', 10
    msg_num3_len equ $ - msg_num3

section .bss
    largest_number resb 1

section .text
_start:
    mov al, [num1]
    cmp al, [num2]            ; Compare NUM1 with NUM2 as signed values.
    jg check_num1_vs_num3     ; Jump if NUM1 is greater than NUM2.

    mov al, [num2]
    cmp al, [num3]            ; Compare NUM2 with NUM3 as signed values.
    jge largest_num2          ; Jump if NUM2 is greater than or equal to NUM3.
    jmp largest_num3

check_num1_vs_num3:
    cmp al, [num3]            ; Compare NUM1 with NUM3.
    jge largest_num1
    jmp largest_num3

    ; JG is used because one number is negative.
    ; JA would treat -12 as unsigned 244, which gives an incorrect comparison.

largest_num1:
    mov byte [largest_number], 1
    mov ecx, msg_num1
    mov edx, msg_num1_len
    call print_string
    jmp exit_program

largest_num2:
    mov byte [largest_number], 2
    mov ecx, msg_num2
    mov edx, msg_num2_len
    call print_string
    jmp exit_program

largest_num3:
    mov byte [largest_number], 3
    mov ecx, msg_num3
    mov edx, msg_num3_len
    call print_string

exit_program:
    mov eax, 1
    xor ebx, ebx
    int 80h

print_string:
    mov eax, 4
    mov ebx, 1
    int 80h
    ret