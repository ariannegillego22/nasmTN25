; Problem 3 - Student Grade Evaluation

global _start

section .data
    prompt_name     db "Enter student name: ", 0
    prompt_id       db "Enter student ID: ", 0
    prompt_grade    db "Enter grade: ", 0

    label_name      db "Student Name: ", 0
    label_id        db "Student ID: ", 0
    label_grade     db "Grade: ", 0
    label_class     db "Classification: ", 0

    excellent       db "Excellent", 0
    very_good       db "Very Good", 0
    good            db "Good", 0
    passed          db "Passed", 0
    failed          db "Failed", 0
    invalid         db "INVALID GRADE", 10, 0
    newline         db 10, 0

section .bss
    student_name    resb 128
    student_id      resb 32
    grade_text      resb 16
    grade_value     resd 1

section .text
_start:
    ; Get student name
    mov ecx, prompt_name
    call print_string
    mov ecx, student_name
    mov edx, 128
    call read_line

    ; Get student ID as text to preserve leading zeroes
    mov ecx, prompt_id
    call print_string
    mov ecx, student_id
    mov edx, 32
    call read_line

    ; Get grade
    mov ecx, prompt_grade
    call print_string
    mov ecx, grade_text
    mov edx, 16
    call read_line

    ; Convert and validate ASCII grade input
    call parse_grade
    jc invalid_grade
    mov [grade_value], eax

    ; Display student details
    mov ecx, label_name
    call print_string
    mov ecx, student_name
    call print_string
    mov ecx, newline
    call print_string

    mov ecx, label_id
    call print_string
    mov ecx, student_id
    call print_string
    mov ecx, newline
    call print_string

    mov ecx, label_grade
    call print_string
    mov ecx, grade_text
    call print_string
    mov ecx, newline
    call print_string

    mov ecx, label_class
    call print_string

    mov eax, [grade_value]

    cmp eax, 90
    jae show_excellent

    cmp eax, 85
    jae show_very_good

    cmp eax, 80
    jae show_good

    cmp eax, 75
    jae show_passed

    jmp show_failed

show_excellent:
    mov ecx, excellent
    jmp show_result

show_very_good:
    mov ecx, very_good
    jmp show_result

show_good:
    mov ecx, good
    jmp show_result

show_passed:
    mov ecx, passed
    jmp show_result

show_failed:
    mov ecx, failed

show_result:
    call print_string
    mov ecx, newline
    call print_string
    jmp exit_program

invalid_grade:
    mov ecx, invalid
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

parse_grade:
    xor eax, eax
    xor edi, edi
    mov esi, grade_text

.next_digit:
    movzx ecx, byte [esi]
    test ecx, ecx
    jz .finish

    cmp cl, '0'
    jb .bad

    cmp cl, '9'
    ja .bad

    inc edi
    cmp edi, 3
    ja .bad

    sub ecx, '0'
    imul eax, eax, 10
    add eax, ecx

    inc esi
    jmp .next_digit

.finish:
    test edi, edi
    jz .bad

    cmp eax, 100
    ja .bad

    clc
    ret

.bad:
    stc
    ret