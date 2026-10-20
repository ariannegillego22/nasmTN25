global _start

section .data
    menu db "----------------------------",10
         db "MENU",10
         db "[A]dd",10
         db "[S]ubtract",10
         db "[M]ultiply",10
         db "[D]ivide",10
         db "----------------------------",10
         db "Enter your choice: ",0

    first_prompt  db "Enter first number (0-99): ",0
    second_prompt db "Enter second number (0-99): ",0

    sum_msg       db "The sum is ",0
    difference_msg db "The difference is ",0
    product_msg   db "The product is ",0
    quotient_msg  db "The quotient is ",0
    remainder_msg db " with remainder ",0

    again_prompt db 10,"Do you want to try again? (Y/N): ",0
    invalid_choice db "Invalid choice. Choose A, S, M, or D.",10,0
    invalid_number db "Invalid number. Enter a number from 0 to 99.",10,0
    invalid_again db "Please enter Y or N.",10,0
    zero_msg db "Cannot divide by zero.",10,0
    goodbye db "Program terminated.",10,0

    newline db 10,0
    clear_code db 27,"[2J",27,"[H",0

section .bss
    input       resb 16
    input_char  resb 1
    input_length resd 1

    choice      resb 1
    number1     resd 1
    number2     resd 1
    result      resd 1
    remainder   resd 1
    output      resb 16

section .text

_start:
    call clear_screen

main_menu:
    mov ecx, menu
    call print_string
    call read_line

    cmp eax, 1
    jne bad_choice

    mov al, [input]
    and al, 0DFh             ; Convert lowercase to uppercase
    mov [choice], al

    cmp al, 'A'
    je get_numbers
    cmp al, 'S'
    je get_numbers
    cmp al, 'M'
    je get_numbers
    cmp al, 'D'
    je get_numbers

bad_choice:
    mov ecx, invalid_choice
    call print_string
    jmp main_menu

get_numbers:
    mov ecx, first_prompt
    call read_number
    mov [number1], eax

    mov ecx, second_prompt
    call read_number
    mov [number2], eax

    mov al, [choice]

    cmp al, 'A'
    je do_add
    cmp al, 'S'
    je do_subtract
    cmp al, 'M'
    je do_multiply
    jmp do_divide

do_add:
    call add_numbers
    mov [result], eax
    mov ecx, sum_msg
    jmp show_result

do_subtract:
    call subtract_numbers
    mov [result], eax
    mov ecx, difference_msg
    jmp show_result

do_multiply:
    call multiply_numbers
    mov [result], eax
    mov ecx, product_msg
    jmp show_result

do_divide:
    cmp dword [number2], 0
    je division_error

    call divide_numbers
    mov [result], eax
    mov [remainder], edx

    mov ecx, quotient_msg
    call print_string

    mov eax, [result]
    call print_number

    mov ecx, remainder_msg
    call print_string

    mov eax, [remainder]
    call print_number

    mov ecx, newline
    call print_string
    jmp ask_again

division_error:
    mov ecx, zero_msg
    call print_string
    jmp ask_again

show_result:
    call print_string
    mov eax, [result]
    call print_number

    mov ecx, newline
    call print_string

ask_again:
    mov ecx, again_prompt
    call print_string
    call read_line

    cmp eax, 1
    jne bad_again

    mov al, [input]
    and al, 0DFh

    cmp al, 'Y'
    je restart
    cmp al, 'N'
    je finish

bad_again:
    mov ecx, invalid_again
    call print_string
    jmp ask_again

restart:
    call clear_screen
    jmp main_menu

finish:
    mov ecx, goodbye
    call print_string

exit_program:
    mov eax, 1               ; sys_exit
    xor ebx, ebx
    int 0x80


; Arithmetic procedures


add_numbers:
    mov eax, [number1]
    add eax, [number2]
    ret

subtract_numbers:
    mov eax, [number1]
    sub eax, [number2]
    ret

multiply_numbers:
    mov eax, [number1]
    imul eax, [number2]
    ret

divide_numbers:
    mov eax, [number1]
    xor edx, edx
    div dword [number2]       ; EAX = quotient, EDX = remainder
    ret

; Clear the terminal

clear_screen:
    mov ecx, clear_code
    call print_string
    ret


; Print a zero-terminated string
; Input: ECX = string address


print_string:
    pushad

    xor edx, edx

.find_end:
    cmp byte [ecx + edx], 0
    je .write
    inc edx
    jmp .find_end

.write:
    mov eax, 4               ; sys_write
    mov ebx, 1               ; stdout
    int 0x80

    popad
    ret


; Read one full line into input
; Returns EAX = length, or -1 if too long
; Reading byte by byte also drains excess
; characters before the next prompt.


read_line:
    pushad
    xor esi, esi             ; Stored character count
    xor edi, edi             ; Overflow flag

.read:
    mov eax, 3               ; sys_read
    xor ebx, ebx             ; stdin
    mov ecx, input_char
    mov edx, 1
    int 0x80

    cmp eax, 0
    jle exit_program

    mov al, [input_char]

    cmp al, 10               ; Enter / newline
    je .done
    cmp al, 13               ; Ignore carriage return
    je .read

    cmp esi, 15
    jae .overflow

    mov [input + esi], al
    inc esi
    jmp .read

.overflow:
    mov edi, 1
    jmp .read

.done:
    mov byte [input + esi], 0
    mov [input_length], esi

    test edi, edi
    jz .return
    mov dword [input_length], -1

.return:
    popad
    mov eax, [input_length]
    ret


; Read and validate a number from 0-99
; Input: ECX = prompt address
; Returns EAX = converted number


read_number:
    push ebx
    push esi
    push edi

    mov edi, ecx             ; Save prompt address

.retry:
    mov ecx, edi
    call print_string
    call read_line

    cmp eax, 1
    jl .invalid
    cmp eax, 2
    jg .invalid

    mov esi, input
    xor eax, eax

.convert:
    movzx ebx, byte [esi]

    test ebx, ebx
    jz .valid

    cmp ebx, '0'
    jb .invalid
    cmp ebx, '9'
    ja .invalid

    sub ebx, '0'             ; ASCII digit to number
    imul eax, eax, 10
    add eax, ebx

    inc esi
    jmp .convert

.invalid:
    mov ecx, invalid_number
    call print_string
    jmp .retry

.valid:
    pop edi
    pop esi
    pop ebx
    ret


; Print a signed integer
; Input: EAX = number


print_number:
    pushad

    lea esi, [output + 15]
    mov byte [esi], 0

    xor edi, edi             ; Negative flag
    test eax, eax
    jns .prepare

    mov edi, 1
    neg eax

.prepare:
    mov ebx, 10

.convert:
    xor edx, edx
    div ebx
    add dl, '0'

    dec esi
    mov [esi], dl

    test eax, eax
    jnz .convert

    test edi, edi
    jz .print

    dec esi
    mov byte [esi], '-'

.print:
    mov ecx, esi
    call print_string

    popad
    ret

section .note.GNU-stack noalloc noexec nowrite progbits