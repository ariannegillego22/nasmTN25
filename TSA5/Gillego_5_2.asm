GLOBAL _start

SECTION .data
during_msg db "System call executed while registers were saved.", 10
during_len equ $ - during_msg

success_msg db "Success: Original register values were restored!", 10
success_len equ $ - success_msg

fail_msg db "Error: Register values were not restored.", 10
fail_len equ $ - fail_msg

SECTION .text
_start:
    ; Load EAX, EBX, ECX, and EDX with distinct known values.
    mov eax, 11111111h
    mov ebx, 22222222h
    mov ecx, 33333333h
    mov edx, 44444444h

    ; Save the original register values.
    push eax
    push ebx
    push ecx
    push edx

    ; sys_write overwrites the registers with its own arguments.
    mov eax, 4
    mov ebx, 1
    mov ecx, during_msg
    mov edx, during_len
    int 0x80

    ; POP must be in reverse order because the stack follows LIFO:
    ; Last In, First Out.
    pop edx
    pop ecx
    pop ebx
    pop eax

    ; Check whether the original values were restored.
    cmp eax, 11111111h
    jne restore_failed

    cmp ebx, 22222222h
    jne restore_failed

    cmp ecx, 33333333h
    jne restore_failed

    cmp edx, 44444444h
    jne restore_failed

    ; Second sys_write: confirmation message.
    mov eax, 4
    mov ebx, 1
    mov ecx, success_msg
    mov edx, success_len
    int 0x80
    jmp exit_program

restore_failed:
    mov eax, 4
    mov ebx, 1
    mov ecx, fail_msg
    mov edx, fail_len
    int 0x80

exit_program:
    mov eax, 1                 ; sys_exit
    xor ebx, ebx
    int 0x80