
global _start

section .data
    even_text db 'Computed value is EVEN.', 10
    even_len equ $ - even_text

    odd_text db 'Computed value 15 is ODD.', 10
    odd_len equ $ - odd_text

section .bss
    computed_value resb 1

section .text
_start:
    mov al, 7
    add al, 8
    mov [computed_value], al

    ; TEST checks bit 0 without changing AL.
    ; AND would change AL, but TEST only changes the flags.
    test al, 1
    jz even_number

    mov ecx, odd_text
    mov edx, odd_len
    call print_string
    jmp exit_program

even_number:
    mov ecx, even_text
    mov edx, even_len
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