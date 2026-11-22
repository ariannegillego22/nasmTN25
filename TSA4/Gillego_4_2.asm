global _start

section .data
    numbers db 3, 5, 7, 9, 1
    ARR_LEN equ $ - numbers

    done_msg db 'All array elements were checked within bounds.', 10
    done_msg_len equ $ - done_msg

section .bss
    current_element resb 1

section .text
_start:
    xor esi, esi              ; ESI is the array index, starting at 0.

check_bounds:
    cmp esi, ARR_LEN
    jae finished              ; Stop if index is above or equal to the array length.

    mov al, [numbers + esi]   ; Access the current element only while index is valid.
    mov [current_element], al
    inc esi
    jmp check_bounds

finished:
    ; Array indices and lengths cannot be negative, so unsigned jumps are correct.
    ; JAE/JB checks the index as an unsigned value, unlike signed JL/JGE.

    mov ecx, done_msg
    mov edx, done_msg_len
    call print_string

    mov eax, 1
    xor ebx, ebx
    int 80h

print_string:
    mov eax, 4
    mov ebx, 1
    int 80h
    ret