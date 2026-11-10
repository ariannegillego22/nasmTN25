

section .data
    numbers     db 1, 2, 1, 3, 2
    ARRAY_LEN   equ 5

    resultMsg   db "Sum of the array: "
    resultLen   equ $ - resultMsg
    newline     db 10

section .bss
    sum         resb 1
    asciiSum    resb 1

section .text
    global _start

_start:
    xor eax, eax
    xor esi, esi
    mov ecx, ARRAY_LEN

sum_loop:
    ; Indexed addressing: accesses each element using [numbers + esi]
    add al, [numbers + esi]
    inc esi
    loop sum_loop

    ; Store computed sum in .bss
    mov [sum], al

    ; Convert numeric sum 9 to ASCII character '9'
    add al, '0'
    mov [asciiSum], al

    ; Display result message
    mov eax, 4
    mov ebx, 1
    mov ecx, resultMsg
    mov edx, resultLen
    int 0x80

    ; Display sum
    mov eax, 4
    mov ebx, 1
    mov ecx, asciiSum
    mov edx, 1
    int 0x80

    ; New line
    mov eax, 4
    mov ebx, 1
    mov ecx, newline
    mov edx, 1
    int 0x80

    ; Exit program
    mov eax, 1
    xor ebx, ebx
    int 0x80