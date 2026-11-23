GLOBAL _start

; Makes PROC/ENDP style valid in NASM
%macro PROC 1
%1:
%endmacro

%macro ENDP 0
%endmacro

SECTION .data
msg db "Hello! This message came from a procedure.", 10
msg_len equ $ - msg

SECTION .text
_start:
    ; CALL pushes the return address onto the stack before transferring control.
    call display_msg

    mov esi, 1                 ; Some main-program instruction

    ; The same procedure is called again without duplicating its code.
    call display_msg

    ; Cleanly terminate the main program using sys_exit.
    mov eax, 1
    xor ebx, ebx
    int 0x80

PROC display_msg
    mov eax, 4                 ; sys_write
    mov ebx, 1                 ; Standard output
    mov ecx, msg
    mov edx, msg_len
    int 0x80

    ; RET pops the return address pushed by CALL and resumes after that CALL.
    ret
ENDP