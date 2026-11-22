
global _start

section .data
    carry_set_text db 'ADD: 250 + 10 = 4 (Carry flag set: unsigned overflow occurred)', 10
    carry_set_len equ $ - carry_set_text

    carry_clear_text db 'ADD: Carry flag clear', 10
    carry_clear_len equ $ - carry_clear_text

    sub_text db 'SUB: 20 - 5 = 15 (no borrow; Carry flag clear)', 10
    sub_len equ $ - sub_text

    borrow_text db 'SUB: borrow occurred', 10
    borrow_len equ $ - borrow_text

section .bss
    add_result resb 1
    sub_result resb 1

section .text
_start:
    mov al, 250
    add al, 10
    jc add_had_carry

    mov [add_result], al
    mov ecx, carry_clear_text
    mov edx, carry_clear_len
    call print_string
    jmp do_subtraction

add_had_carry:
    ; CF = 1 because 250 + 10 is 260, which is larger than 255.
    mov [add_result], al
    mov ecx, carry_set_text
    mov edx, carry_set_len
    call print_string

do_subtraction:
    mov al, 20
    sub al, 5
    jnc subtraction_no_borrow

subtraction_borrow:
    mov [sub_result], al
    mov ecx, borrow_text
    mov edx, borrow_len
    call print_string
    jmp exit_program

subtraction_no_borrow:
    mov [sub_result], al
    mov ecx, sub_text
    mov edx, sub_len
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