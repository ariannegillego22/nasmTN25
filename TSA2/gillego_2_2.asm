

section .data
    SCORES      db 4, 7, 2, 9, 5
    message     db "Third score retrieved: "
    message_len equ $ - message
    newline     db 10

section .bss
    extraByte   resb 1
    valueChar   resb 1

section .text
    global _start

_start:
    ; Direct-offset addressing: third element, SCORES[2] = 2
    mov al, [SCORES + 2]

    ; Direct-offset addressing: fifth element, SCORES[4] = 5
    mov dl, [SCORES + 4]

    mov ebx, extraByte

    ; BYTE is needed because NASM does not know the size of [ebx].
    mov BYTE [ebx], 95

    ; Convert score to ASCII
    add al, '0'
    mov [valueChar], al

    ; Display message
    mov eax, 4
    mov ebx, 1
    mov ecx, message
    mov edx, message_len
    int 0x80

    ; Display retrieved score
    mov eax, 4
    mov ebx, 1
    mov ecx, valueChar
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