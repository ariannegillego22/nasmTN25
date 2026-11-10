section .data
    prompt      db "Enter your name: "
    prompt_len  equ $ - prompt
    confirm     db "You entered: "
    confirm_len equ $ - confirm

section .bss
    inputBuffer resb 50

section .text
    global _start

_start:
    ; Display prompt using sys_write
    mov eax, 4
    mov ebx, 1
    mov ecx, prompt
    mov edx, prompt_len
    int 0x80

    ; Read user input using sys_read
    mov eax, 3
    mov ebx, 0
    mov ecx, inputBuffer
    mov edx, 50
    int 0x80
    mov esi, eax

    ; Display confirmation message
    mov eax, 4
    mov ebx, 1
    mov ecx, confirm
    mov edx, confirm_len
    int 0x80

    ; Echo the input
    mov eax, 4
    mov ebx, 1
    mov ecx, inputBuffer
    mov edx, esi
    int 0x80

    ; Exit program
    mov eax, 1
    mov ebx, 0
    int 0x80