

section .data
    VAL_A       dw 111
    VAL_B       dw 222
    swappedMsg  db "Values swapped successfully.", 10
    swappedLen  equ $ - swappedMsg

section .text
    global _start

_start:
    ; Five valid MOV forms:
    ; 1. MOV register, register
    ; 2. MOV register, immediate
    ; 3. MOV register, memory
    ; 4. MOV memory, register
    ; 5. MOV memory, immediate
    ;
    ; MOV memory, memory is INVALID.
    ; Registers must be used as intermediate storage.

    ; Store addresses using indirect addressing
    mov ebx, VAL_A
    mov esi, VAL_B

    ; Swap values through registers
    mov ax, [ebx]
    mov dx, [esi]

    mov [ebx], dx
    mov [esi], ax

    ; Display confirmation message
    mov eax, 4
    mov ebx, 1
    mov ecx, swappedMsg
    mov edx, swappedLen
    int 0x80

    ; Exit program
    mov eax, 1
    xor ebx, ebx
    int 0x80