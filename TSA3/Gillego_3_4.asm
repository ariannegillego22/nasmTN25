
global _start

section .data
    result_text db 'AND: 3A AND 0F = 0A | OR: 0A OR 0F = 0F | XOR EAX,EAX = 0 | NOT 3A = C5', 10
    result_len equ $ - result_text

section .bss
    and_result resb 1
    or_result  resb 1
    not_result resb 1

section .text
_start:
    mov al, 00111010b
    and al, 0Fh
    ; AND masking removes the high nibble while keeping the low nibble.
    mov [and_result], al

    or al, 0Fh
    ; OR forces all bits in the low nibble to become 1.
    mov [or_result], al

    xor eax, eax
    ; XOR with itself makes EAX zero. It is compact and does not need a zero value.

    mov al, 00111010b
    not al
    ; NOT flips every bit. It is one's complement, not arithmetic negation.
    mov [not_result], al

    mov ecx, result_text
    mov edx, result_len
    call print_string

    mov eax, 1
    xor ebx, ebx
    int 80h

print_string:
    mov eax, 4
    mov ebx, 1
    int 80h
    ret