; Problem 4 - ATM Withdrawal Validation

global _start

section .data
    balance          dd 10000

    prompt_name      db "Enter account name: ", 0
    prompt_pin       db "Enter PIN: ", 0
    prompt_amount    db "Enter withdrawal amount: ", 0
    correct_pin      db "1234", 0

    access_granted   db "ACCESS GRANTED", 10, 0
    access_denied    db "ACCESS DENIED", 10, 0
    current_balance  db "Current Balance: PHP ", 0
    success          db "WITHDRAWAL SUCCESSFUL", 10, 0
    withdrawn_label  db "Amount Withdrawn: PHP ", 0
    remaining_label  db "Remaining Balance: PHP ", 0
    invalid_amount   db "INVALID AMOUNT", 10, 0
    insufficient     db "INSUFFICIENT FUNDS", 10, 0
    not_multiple     db "AMOUNT MUST BE A MULTIPLE OF 100", 10, 0
    newline          db 10, 0

section .bss
    account_name     resb 128
    pin_input        resb 16
    amount_text      resb 16
    withdrawal       resd 1
    number_buffer    resb 12

section .text
_start:
    ; Get account name
    mov ecx, prompt_name
    call print_string
    mov ecx, account_name
    mov edx, 128
    call read_line

    ; Get PIN
    mov ecx, prompt_pin
    call print_string
    mov ecx, pin_input
    mov edx, 16
    call read_line

    ; Check if PIN is 1234
    mov esi, pin_input
    mov edi, correct_pin
    call strings_equal
    test eax, eax
    jz denied

    ; Correct PIN
    mov ecx, access_granted
    call print_string

    mov ecx, current_balance
    call print_string
    mov eax, [balance]
    call print_number
    mov ecx, newline
    call print_string

    ; Get withdrawal amount
    mov ecx, prompt_amount
    call print_string
    mov ecx, amount_text
    mov edx, 16
    call read_line

    ; Convert amount from ASCII to a number
    call parse_positive_amount
    jc invalid
    mov [withdrawal], eax

    ; Check if amount is greater than balance
    cmp eax, [balance]
    ja insufficient_funds

    ; Check if amount is divisible by 100
    xor edx, edx
    mov ebx, 100
    div ebx
    test edx, edx
    jnz multiple_error

    ; Deduct amount from balance
    mov eax, [balance]
    sub eax, [withdrawal]
    mov [balance], eax

    mov ecx, success
    call print_string

    mov ecx, withdrawn_label
    call print_string
    mov eax, [withdrawal]
    call print_number
    mov ecx, newline
    call print_string

    mov ecx, remaining_label
    call print_string
    mov eax, [balance]
    call print_number
    mov ecx, newline
    call print_string
    jmp exit_program

denied:
    mov ecx, access_denied
    call print_string
    jmp exit_program

invalid:
    mov ecx, invalid_amount
    call print_string
    jmp exit_program

insufficient_funds:
    mov ecx, insufficient
    call print_string
    jmp exit_program

multiple_error:
    mov ecx, not_multiple
    call print_string

exit_program:
    mov eax, 1
    xor ebx, ebx
    int 0x80

print_string:
    push eax
    push ebx
    push ecx
    push edx

    mov edx, ecx

.find_end:
    cmp byte [edx], 0
    je .write
    inc edx
    jmp .find_end

.write:
    sub edx, ecx
    mov eax, 4
    mov ebx, 1
    int 0x80

    pop edx
    pop ecx
    pop ebx
    pop eax
    ret


read_line:
    push eax
    push ebx
    push esi

    dec edx
    mov eax, 3
    mov ebx, 0
    int 0x80

    cmp eax, 0
    jle .empty

    mov esi, ecx
    add esi, eax
    dec esi

    cmp byte [esi], 10
    jne .terminate

    mov byte [esi], 0
    jmp .done

.terminate:
    mov byte [ecx + eax], 0
    jmp .done

.empty:
    mov byte [ecx], 0

.done:
    pop esi
    pop ebx
    pop eax
    ret


strings_equal:
.compare:
    mov al, [esi]
    cmp al, [edi]
    jne .not_equal

    test al, al
    jz .equal

    inc esi
    inc edi
    jmp .compare

.equal:
    mov eax, 1
    ret

.not_equal:
    xor eax, eax
    ret


parse_positive_amount:
    xor eax, eax
    xor edi, edi
    xor ebp, ebp
    mov esi, amount_text

.next_digit:
    movzx ecx, byte [esi]
    test ecx, ecx
    jz .finish

    cmp cl, '0'
    jb .bad

    cmp cl, '9'
    ja .bad

    inc edi
    test ebp, ebp
    jnz .continue

    sub ecx, '0'
    imul eax, eax, 10
    add eax, ecx

    cmp eax, 10000
    jbe .continue

    mov ebp, 1

.continue:
    inc esi
    jmp .next_digit

.finish:
    test edi, edi
    jz .bad

    test ebp, ebp
    jz .check_zero

    mov eax, 10001
    clc
    ret

.check_zero:
    test eax, eax
    jz .bad

    clc
    ret

.bad:
    stc
    ret


; Prints a nonnegative number in EAX
print_number:
    push eax
    push ebx
    push ecx
    push edx
    push edi

    mov edi, number_buffer + 11
    mov byte [edi], 0

    cmp eax, 0
    jne .convert

    dec edi
    mov byte [edi], '0'
    jmp .print

.convert:
    xor edx, edx
    mov ebx, 10
    div ebx

    add dl, '0'
    dec edi
    mov [edi], dl

    test eax, eax
    jnz .convert

.print:
    mov ecx, edi
    call print_string

    pop edi
    pop edx
    pop ecx
    pop ebx
    pop eax
    ret