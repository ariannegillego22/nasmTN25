; CERTIFICATE OF REGISTRATION


BITS 32
global _start

FIELD_COUNT equ 12
COURSE_COUNT equ 11
TEXT_SIZE equ 128
FEE_COUNT equ 5


; ---> MACROS

; to print a string.
%macro PRINT 1
    push ecx
    mov ecx, %1
    call print_string
    pop ecx
%endmacro

; to ask for text and store the answer.
%macro INPUT 2
    mov ecx, %1
    mov edi, %2
    call input_text
%endmacro

; to print an unsigned number.
%macro NUMBER 1
    mov eax, %1
    call print_number
%endmacro



; ---> INITIALIZED DATA


section .data

    welcome db "---CERTIFICATE OF REGISTRATION---",10,10,0

    part1 db "PART 1: STUDENT INFORMATION",10
          db "========================================",10,0

    part2 db 10
          db "PART 2: SCHEDULE AND UNITS",10
          db "========================================",10,0

    part3 db 10
          db "PART 3: ASSESSMENT OF SCHOOL FEES",10
          db "========================================",10,0

    colon db ": ",0
    newline db 10,0
    line db "========================================",10,0

    ; Student information labels.
    student_label db "Student number",0
    name_label db "Full name",0
    college_label db "College",0
    program_label db "Program",0
    year_label db "Year level",0
    term_label db "Term",0
    school_year_label db "School year",0
    status_label db "Enrollment status",0
    phone_label db "Phone number",0
    address_label db "Address",0
    zip_label db "Zip code",0
    classification_label db "Classification",0

    align 4

    labels:
        dd student_label, name_label
        dd college_label, program_label
        dd year_label, term_label
        dd school_year_label, status_label
        dd phone_label, address_label
        dd zip_label, classification_label

    units_prompt db "Enter units for this course (0-30): ",0
    rate_prompt db "Enter tuition rate per unit in PHP: ",0

    invalid_number db "Invalid number. Please try again.",10,0
    invalid_text db "Please enter 1 to 127 characters.",10,0

    cor_heading db 10
                db "========================================",10
                db "    CERTIFICATE OF REGISTRATION",10
                db "========================================",10,10,0

    course_heading db "Code | Title | Section | Schedule | Room",10,0

    units_label db "Units: ",0
    total_label db "TOTAL UNITS: ",0
    rate_label db "TUITION RATE PER UNIT: PHP ",0
    tuition_label db "TUITION FEE: PHP ",0
    peso_label db "PHP ",0
    cents db ".00",10,0

    other_total_label db "TOTAL OTHER SCHOOL FEES: PHP ",0
    assessment_label db "TOTAL ASSESSMENT: PHP ",0

    ; School fee names.
    misc_name db "Miscellaneous Fee",0
    id_name db "ID Validation Fee",0
    lab_ccs_name db "CCS0021 Laboratory Fee",0
    lab_csa_name db "CS0003 Laboratory Fee",0
    lab_oop_name db "CS0070 Laboratory Fee",0

    align 4

    ; Each entry contains the name address and amount.
    school_fees:
        dd misc_name, 12305
        dd id_name, 80
        dd lab_ccs_name, 4008
        dd lab_csa_name, 4008     ; Assumed amount; verify.
        dd lab_oop_name, 4008

    ; Course information from the COR.
    course1 db "CCS0021 | INFORMATION MANAGEMENT (LEC)"
            db " | TN23 | F 10:00-12:40 | ONLINE",0

    course2 db "CCS0021L | INFORMATION MANAGEMENT (LAB)"
            db " | TN23 | T 10:00-12:50 | ONLINE",0

    course3 db "CS0001 | DISCRETE STRUCTURES 1"
            db " | TN24 | S/W 15:00-16:50 | F710",0

    course4 db "CS0003 | COMPUTER SYSTEMS & ARCHITECTURE"
            db " | TN25 | T 16:00-18:40 | ONLINE",0

    course5 db "CS0003L | COMPUTER SYSTEMS & ARCHITECTURE (LAB)"
            db " | TN25 | TH 16:00-18:50 | E610",0

    course6 db "CS0070 | OBJECT ORIENTED PROGRAMMING"
            db " | TN24 | F 07:00-09:40 | ONLINE",0

    course7 db "CS0070L | OBJECT ORIENTED PROGRAMMING (LAB)"
            db " | TN24 | TH 07:00-09:50 | E609",0

    course8 db "GED0021 | SPECIALIZED ENGLISH PROGRAM 2"
            db " | TN23 | S/W 13:00-14:50 | F607",0

    course9 db "GED0055 | MATHEMATICAL ANALYSIS"
            db " | M552 | S/W 07:00-08:50 | F712",0

    course10 db "GED0081 | COLLEGE PHYSICS 1 LECTURE"
             db " | TN22 | F 13:00-15:40 | ONLINE",0

    course11 db "GED0081L | COLLEGE PHYSICS 1 LABORATORY"
             db " | TN22 | TH 13:00-15:50 | F1003",0

    align 4

    courses:
        dd course1, course2, course3
        dd course4, course5, course6
        dd course7, course8, course9
        dd course10, course11


; --->UNINITIALIZED DATA

section .bss

    information resb FIELD_COUNT * TEXT_SIZE

    alignb 4

    course_units resd COURSE_COUNT

    tuition_rate resd 1
    total_units resd 1
    tuition_fee resd 1

    other_fees_total resd 1
    total_assessment resd 1

    input_buffer resb TEXT_SIZE
    input_character resb 1
    number_buffer resb 11

; ---> MAIN PROGRAM


section .text

_start:
    cld

    PRINT welcome

    ; Part 1: Enter student information.
    PRINT part1
    call input_information

    ; Part 2: Enter units and tuition rate.
    PRINT part2
    call input_course_units
    call input_tuition_rate

    ; Compute tuition and assessment.
    call compute_tuition
    call compute_assessment

    ; Print the complete COR.
    call print_cor

    ; Exit successfully.
    mov eax, 1
    xor ebx, ebx
    int 0x80


; ---> INPUT STUDENT INFORMATION


input_information:
    mov esi, labels
    mov edi, information
    mov ebp, FIELD_COUNT

.next_field:
    INPUT [esi], edi

    add esi, 4
    add edi, TEXT_SIZE

    dec ebp
    jnz .next_field

    ret

; ---> INPUT COURSE UNITS


input_course_units:
    mov esi, courses
    mov edi, course_units
    mov ebp, COURSE_COUNT

.next_course:
    PRINT [esi]
    PRINT newline

    mov ecx, units_prompt

    ; Accept 0 to 30 units.
    xor ebx, ebx
    mov edx, 30

    call input_number

    PRINT newline

    add esi, 4
    add edi, 4

    dec ebp
    jnz .next_course

    ret


; ---> INPUT TUITION RATE

input_tuition_rate:
    mov ecx, rate_prompt
    mov edi, tuition_rate

    ; Accept PHP 1 to PHP 100000.
    mov ebx, 1
    mov edx, 100000

    call input_number
    ret



; ---> COMPUTE TOTAL UNITS AND TUITION


compute_tuition:
    pushad

    xor eax, eax
    mov esi, course_units
    mov ecx, COURSE_COUNT

.add_units:
    add eax, [esi]
    add esi, 4

    loop .add_units

    mov [total_units], eax

    ; Tuition = total units * rate per unit.
    imul eax, [tuition_rate]
    mov [tuition_fee], eax

    popad
    ret



; ---> COMPUTE SCHOOL FEES AND ASSESSMENT


compute_assessment:
    pushad

    xor eax, eax
    mov esi, school_fees
    mov ecx, FEE_COUNT

.add_fee:
    add eax, [esi + 4]
    add esi, 8

    loop .add_fee

    mov [other_fees_total], eax

    ; Assessment = tuition + school fees.
    add eax, [tuition_fee]
    mov [total_assessment], eax

    popad
    ret


; PRINT COMPLETE COR

print_cor:
    pushad

    PRINT cor_heading

    ; Part 1: Student information.
    PRINT part1

    mov esi, labels
    mov edi, information
    mov ebp, FIELD_COUNT

.print_information:
    PRINT [esi]
    PRINT colon
    PRINT edi
    PRINT newline

    add esi, 4
    add edi, TEXT_SIZE

    dec ebp
    jnz .print_information

    ; Part 2: Schedule and units.
    PRINT part2
    PRINT course_heading

    mov esi, courses
    mov edi, course_units
    mov ebp, COURSE_COUNT

.print_courses:
    PRINT [esi]
    PRINT newline

    PRINT units_label
    NUMBER [edi]

    PRINT newline
    PRINT newline

    add esi, 4
    add edi, 4

    dec ebp
    jnz .print_courses

    PRINT total_label
    NUMBER [total_units]
    PRINT newline

    PRINT rate_label
    NUMBER [tuition_rate]
    PRINT cents

    ; Part 3: Assessment.
    PRINT part3

    PRINT tuition_label
    NUMBER [tuition_fee]
    PRINT cents

    call print_school_fees

    PRINT line

    PRINT other_total_label
    NUMBER [other_fees_total]
    PRINT cents

    PRINT assessment_label
    NUMBER [total_assessment]
    PRINT cents

    PRINT line

    popad
    ret


; PRINT SCHOOL FEES

print_school_fees:
    pushad

    mov esi, school_fees
    mov ebp, FEE_COUNT

.next_fee:
    PRINT [esi]
    PRINT colon
    PRINT peso_label

    NUMBER [esi + 4]
    PRINT cents

    add esi, 8

    dec ebp
    jnz .next_fee

    popad
    ret



; INPUT TEXT

input_text:
    pushad

.retry:
    call print_string
    PRINT colon

    call read_line
    jc .invalid

    ; Require a nonempty answer.
    cmp byte [input_buffer], 0
    je .invalid

    mov esi, input_buffer

.copy:
    lodsb
    stosb

    test al, al
    jnz .copy

    popad
    ret

.invalid:
    PRINT invalid_text
    jmp .retry


; INPUT NUMBER
;
; ECX- prompt address
; EDI- destination address
; EBX- minimum allowed value
; EDX- maximum allowed value


input_number:
    pushad

.retry:
    call print_string
    call read_line
    jc .invalid

    cmp byte [input_buffer], 0
    je .invalid

    ; Preserve prompt and maximum.
    push ecx
    push edx

    mov esi, input_buffer
    xor eax, eax

.convert_digit:
    movzx ecx, byte [esi]

    test ecx, ecx
    jz .check_range

    ; Convert ASCII character to digit.
    sub ecx, '0'

    cmp ecx, 9
    ja .conversion_error

    ; Number = number * 10 + digit.
    mov edx, 10
    mul edx

    ; Reject multiplication overflow.
    test edx, edx
    jnz .conversion_error

    add eax, ecx
    jc .conversion_error

    inc esi
    jmp .convert_digit

.check_range:
    pop edx
    pop ecx

    cmp eax, ebx
    jb .invalid

    cmp eax, edx
    ja .invalid

    mov [edi], eax

    popad
    ret

.conversion_error:
    pop edx
    pop ecx

.invalid:
    PRINT invalid_number
    jmp .retry


; ---> READ LINE


read_line:
    pushad

    xor esi, esi
    xor edi, edi

.read_character:
    mov eax, 3
    xor ebx, ebx
    mov ecx, input_character
    mov edx, 1

    int 0x80

    cmp eax, 1
    jne .end_of_input

    mov al, [input_character]

    cmp al, 10
    je .finish

    ; Ignore carriage return.
    cmp al, 13
    je .read_character

    cmp esi, TEXT_SIZE - 1
    jae .too_long

    mov [input_buffer + esi], al
    inc esi

    jmp .read_character

.too_long:
    ; Consume the rest of an overlong line.
    mov edi, 1
    jmp .read_character

.finish:
    mov byte [input_buffer + esi], 0

    test edi, edi
    jnz .overflow

    popad
    clc
    ret

.overflow:
    popad
    stc
    ret

.end_of_input:
    cmp eax, 0
    jl .read_error

    ; Accept a final line without a newline.
    test esi, esi
    jnz .finish

    ; Exit when no input remains.
    mov eax, 1
    xor ebx, ebx
    int 0x80

.read_error:
    mov eax, 1
    mov ebx, 1
    int 0x80


;---> PRINT STRING


print_string:
    pushad

    mov edx, ecx

.find_length:
    cmp byte [edx], 0
    je .display

    inc edx
    jmp .find_length

.display:
    sub edx, ecx

    mov eax, 4
    mov ebx, 1
    int 0x80

    popad
    ret



; ---> PRINT NUMBER


print_number:
    pushad

    mov edi, number_buffer + 10
    mov byte [edi], 0

    mov ebx, 10

.convert:
    xor edx, edx
    div ebx

    add dl, '0'

    dec edi
    mov [edi], dl

    test eax, eax
    jnz .convert

    mov ecx, edi
    call print_string

    popad
    ret