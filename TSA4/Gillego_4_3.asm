global _start

section .data
    values db 1, 2, 1, 2, 3
    VALUE_COUNT equ $ - values

    sum_msg db 'Sum = '
    sum_msg_len equ $ - sum_msg
    newline db 10

section .bss
    sum_value resb 1
    sum_ascii resb 1

section .text
_start:
    xor eax, eax              ; AL starts at zero and will hold the total.
    mov esi, values           ; ESI points to the first array element.
    mov ecx, VALUE_COUNT      ; ECX contains the number of elements.

sum_loop:
    add al, [esi]             ; Add the current byte to the total.
    inc esi                   ; Move ESI to the next array element.
    loop sum_loop             ; LOOP decreases ECX and jumps while ECX is not zero.

    mov [sum_value], al
    add al, '0'               ; Convert the single-digit sum 9 into ASCII.
    mov [sum_ascii], al

    mov ecx, sum_msg
    mov edx, sum_msg_len
    call print_string

    mov ecx, sum_ascii
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