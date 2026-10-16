; Problem 2 - Student Year Level Classification

section .data

    askName     db "What is your name? "
    askNameLen  equ $-askName

    askAge      db "How old are you? "
    askAgeLen   equ $-askAge

    askYear     db "What is your year level? "
    askYearLen  equ $-askYear

    helloMsg    db "Hello "
    helloMsgLen equ $-helloMsg

    ageMsg      db "You are "
    ageMsgLen   equ $-ageMsg

    yearsMsg    db " years old",10
    yearsMsgLen equ $-yearsMsg

    freshmanMsg db "Freshman",10
    freshmanLen equ $-freshmanMsg

    sophomoreMsg db "Sophomore",10
    sophomoreLen equ $-sophomoreMsg

    juniorMsg   db "Junior",10
    juniorLen   equ $-juniorMsg

    seniorMsg   db "Senior",10
    seniorLen   equ $-seniorMsg

    invalidYearMsg db "INVALID YEAR LEVEL",10
    invalidYearLen equ $-invalidYearMsg

    badAgeMsg   db "Invalid age input!",10
    badAgeLen   equ $-badAgeMsg

    newline db 10

section .bss

    nameBuffer  resb 100
    ageBuffer   resb 20
    yearBuffer  resb 10

    nameLen     resd 1

section .text
global _start

_start:
;name
    mov eax, askName
    mov edx, askNameLen
    call printString

    mov eax, nameBuffer
    mov edx, 100
    call readLine

    mov [nameLen], eax

;age
    mov eax, askAge
    mov edx, askAgeLen
    call printString

    mov eax, ageBuffer
    mov edx, 20
    call readLine

    mov esi, ageBuffer
    call validateNumber

    cmp eax, 0
    jne ageValid

    mov eax, badAgeMsg
    mov edx, badAgeLen
    call printString
    jmp exitProgram

ageValid:

;year level input
    mov eax, askYear
    mov edx, askYearLen
    call printString

    mov eax, yearBuffer
    mov edx, 10
    call readLine

;print hello
    mov eax, helloMsg
    mov edx, helloMsgLen
    call printString

    mov eax, 4
    mov ebx, 1
    mov ecx, nameBuffer
    mov edx, [nameLen]
    int 80h

    mov eax, 4
    mov ebx, 1
    mov ecx, newline
    mov edx, 1
    int 80h

;print age
    mov eax, ageMsg
    mov edx, ageMsgLen
    call printString

    mov esi, ageBuffer
    call strLength

    mov eax, 4
    mov ebx, 1
    mov ecx, ageBuffer
    int 80h

    mov eax, yearsMsg
    mov edx, yearsMsgLen
    call printString

;year level Classification
    mov al, [yearBuffer]

    cmp al, '1'
    je freshman

    cmp al, '2'
    je sophomore

    cmp al, '3'
    je junior

    cmp al, '4'
    je senior

    jmp invalidYear

freshman:
    mov eax, freshmanMsg
    mov edx, freshmanLen
    call printString
    jmp exitProgram

sophomore:
    mov eax, sophomoreMsg
    mov edx, sophomoreLen
    call printString
    jmp exitProgram

junior:
    mov eax, juniorMsg
    mov edx, juniorLen
    call printString
    jmp exitProgram

senior:
    mov eax, seniorMsg
    mov edx, seniorLen
    call printString
    jmp exitProgram

invalidYear:
    mov eax, invalidYearMsg
    mov edx, invalidYearLen
    call printString

exitProgram:
    mov eax, 1
    xor ebx, ebx
    int 80h

printString:
    push ebx
    push ecx

    mov ecx, eax
    mov eax, 4
    mov ebx, 1
    int 80h

    pop ecx
    pop ebx
    ret

readLine:
    push ebx
    push ecx
    push edx

    mov ecx, eax
    mov eax, 3
    mov ebx, 0
    int 80h

    dec eax
    mov [ecx+eax], byte 0

    pop edx
    pop ecx
    pop ebx
    ret

validateNumber:

    mov eax, 1

checkDigit:
    mov bl, [esi]

    cmp bl, 0
    je validDone

    cmp bl, '0'
    jb invalidNum

    cmp bl, '9'
    ja invalidNum

    inc esi
    jmp checkDigit

invalidNum:
    xor eax, eax

validDone:
    ret

strLength:

    xor edx, edx

countLoop:
    cmp byte [esi+edx], 0
    je doneCount

    inc edx
    jmp countLoop

doneCount:
    ret