
; Symbolic constants
BUFFER_SIZE EQU 2
%define PROMPT_LEN prompt_end - prompt

section .data
    prompt      db "Enter one character: "
    prompt_end:

    result      db "You typed: "
    result_len  equ $ - result

    newline     db 10

section .bss
    inputBuffer resb BUFFER_SIZE
    typedChar   resb 1

section .text
    global _start

_start:
    ; Display prompt using sys_write
    mov eax, 4
    mov ebx, 1
    mov ecx, prompt
    mov edx, PROMPT_LEN
    int 0x80

    ; Read one character using sys_read
    mov eax, 3
    mov ebx, 0
    mov ecx, inputBuffer
    mov edx, BUFFER_SIZE
    int 0x80

    ; Direct addressing: get first entered character
    mov al, [inputBuffer]
    mov [typedChar], al

    ; Display result message
    mov eax, 4
    mov ebx, 1
    mov ecx, result
    mov edx, result_len
    int 0x80

    ; Display entered character
    mov eax, 4
    mov ebx, 1
    mov ecx, typedChar
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