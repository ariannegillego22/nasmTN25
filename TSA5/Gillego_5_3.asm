
GLOBAL _start

; Makes PROC/ENDP style valid in NASM
%macro PROC 1
%1:
%endmacro

%macro ENDP 0
%endmacro

SECTION .data
result_msg db "Factorial of 5 is: "
result_len equ $ - result_msg

SECTION .bss
number_buffer resb 12

SECTION .text
_start:
    mov eax, 5                 ; Compute 5!
    call factorial

    ; Display the label first.
    push eax
    mov eax, 4
    mov ebx, 1
    mov ecx, result_msg
    mov edx, result_len
    int 0x80
    pop eax

    ; Convert the factorial result to printable digits.
    call print_number

    mov eax, 1                 ; sys_exit
    xor ebx, ebx
    int 0x80

; Input: EAX = n
; Output: EAX = n!
PROC factorial
    cmp eax, 0
    jne recursive_case

    ; Without this base case, recursive CALLs would continue forever
    ; and eventually fill or overflow the stack.
    mov eax, 1
    ret

recursive_case:
    push eax                   ; Save current n
    dec eax                    ; Compute n - 1
    call factorial             ; factorial(n - 1)

    pop ebx                    ; Restore original n
    imul eax, ebx              ; n * factorial(n - 1)
    ret
ENDP

; Displays the positive number in EAX.
PROC print_number
    mov edi, number_buffer + 11
    mov byte [edi], 10         ; Newline
    mov ebx, 10

convert_digit:
    xor edx, edx
    div ebx                    ; EAX / 10, remainder goes to EDX
    add dl, '0'
    dec edi
    mov [edi], dl

    test eax, eax
    jnz convert_digit

    mov edx, number_buffer + 12
    sub edx, edi               ; Length of number plus newline

    mov eax, 4                 ; sys_write
    mov ebx, 1
    mov ecx, edi
    int 0x80
    ret
ENDP