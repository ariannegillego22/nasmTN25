global _start

section .data
    string1 db 'NASM'
    string2 db 'NASM'
    string3 db 'NEST'
    STR_LEN equ $ - string3

    match_msg db 'Test 1: Strings match.', 10
    match_msg_len equ $ - match_msg

    differ_msg db 'Test 2: Strings differ.', 10
    differ_msg_len equ $ - differ_msg

section .bss
    test1_status resb 1
    test2_status resb 1

section .text
_start:
    cld                       ; Clear DF so ESI and EDI move forward after each CMPSB.

    mov esi, string1
    mov edi, string2
    mov ecx, STR_LEN
    repe cmpsb                ; Compare bytes while equal and while ECX is not zero.
    jne first_different

    mov byte [test1_status], 1
    mov ecx, match_msg
    mov edx, match_msg_len
    call print_string
    jmp second_test

first_different:
    mov byte [test1_status], 0
    mov ecx, differ_msg
    mov edx, differ_msg_len
    call print_string

second_test:
    cld                       ; Make sure the pointers again move forward.
    mov esi, string1
    mov edi, string3
    mov ecx, STR_LEN
    repe cmpsb                ; Stops when bytes differ or ECX reaches zero.
    jne second_different

    mov byte [test2_status], 1
    mov ecx, match_msg
    mov edx, match_msg_len
    call print_string
    jmp exit_program

second_different:
    mov byte [test2_status], 0
    mov ecx, differ_msg
    mov edx, differ_msg_len
    call print_string

exit_program:
    mov eax, 1
    xor ebx, ebx
    int 80h

print_string:
    mov eax, 4
    mov ebx, 1
    int 80h
    ret