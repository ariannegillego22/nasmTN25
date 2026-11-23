
GLOBAL _start

SECTION .data
success_msg db "Memory allocated successfully!", 10
success_len equ $ - success_msg

error_msg db "Memory allocation failed.", 10
error_len equ $ - error_msg

SECTION .bss
current_break resd 1
requested_break resd 1

SECTION .text
_start:
    ; Query the current program break address.
    mov eax, 45                ; sys_brk
    xor ebx, ebx               ; EBX = 0 means query only
    int 0x80
    mov [current_break], eax

    ; Request 4096 additional bytes.
    add eax, 4096
    mov [requested_break], eax

    mov ebx, eax
    mov eax, 45                ; sys_brk
    int 0x80

    ; A negative EAX would indicate that memory allocation failed.
    cmp eax, 0
    jl allocation_failed

    ; Verify that the new program break reached the requested address.
    cmp eax, [requested_break]
    jne allocation_failed

    ; Allocation succeeded.
    mov eax, 4                 ; sys_write
    mov ebx, 1
    mov ecx, success_msg
    mov edx, success_len
    int 0x80
    jmp exit_program

allocation_failed:
    mov eax, 4                 ; sys_write
    mov ebx, 1
    mov ecx, error_msg
    mov edx, error_len
    int 0x80

exit_program:
    mov eax, 1                 ; sys_exit
    xor ebx, ebx
    int 0x80