; Problem 1 - Name, Age, and Gender Greeting


section .data

    askName     db "What is your name? ",
    askNameLen  equ $-askName

    askAge      db "How old are you? ",
    askAgeLen   equ $-askAge

    askGender   db "What is your gender? ",
    askGenderLen equ $-askGender

    helloMsg    db "Hello ",
    helloMsgLen equ $-helloMsg

    ageMsg      db "You are ",
    ageMsgLen   equ $-ageMsg

    yearsMsg    db " years old",10
    yearsMsgLen equ $-yearsMsg

    maleMsg     db "Hello",10
    maleMsgLen  equ $-maleMsg

    femaleMsg   db "World",10
    femaleMsgLen equ $-femaleMsg

    invalidMsg  db "INVALID",10
    invalidMsgLen equ $-invalidMsg

    badAgeMsg   db "Invalid age input!",10
    badAgeMsgLen equ $-badAgeMsg

section .bss

    nameBuffer      resb 100
    ageBuffer       resb 20
    genderBuffer    resb 10

    nameLen         resd 1

section .text
    global _start

_start:

    ; Ask Name
    mov eax, askName
    mov edx, askNameLen
    call printString

    mov eax, nameBuffer
    mov edx, 100
    call readLine

    mov [nameLen], eax

    ; Ask Age
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
    mov edx, badAgeMsgLen
    call printString
    jmp exitProgram

ageValid:

    ; Ask Gender
    mov eax, askGender
    mov edx, askGenderLen
    call printString

    mov eax, genderBuffer
    mov edx, 10
    call readLine

    ; Print Hello <name>
    mov eax, helloMsg
    mov edx, helloMsgLen
    call printString

    mov esi, nameBuffer
    call strLength

    mov eax, 4
    mov ebx, 1
    mov ecx, nameBuffer
    int 80h

    mov eax, 4
    mov ebx, 1
    mov ecx, newline
    mov edx, 1
    int 80h

    ; Print age line
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

    ; Check gender
    mov al, [genderBuffer]

    cmp al, 'M'
    je male

    cmp al, 'm'
    je male

    cmp al, 'F'
    je female

    cmp al, 'f'
    je female

    jmp invalid

male:
    mov eax, maleMsg
    mov edx, maleMsgLen
    call printString
    jmp exitProgram

female:
    mov eax, femaleMsg
    mov edx, femaleMsgLen
    call printString
    jmp exitProgram

invalid:
    mov eax, invalidMsg
    mov edx, invalidMsgLen
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
    mov byte [ecx+eax], 0

    pop edx
    pop ecx
    pop ebx
    ret

removeLF:
    cmp byte [esi], 10
    je foundLF

    inc esi
    loop removeLF

    jmp doneLF

foundLF:
    mov byte [esi], 0

doneLF:
    mov esi, ecx
    dec esi
    mov eax, esi

validateNumber:

    mov eax, 1

nextDigit:
    mov bl, [esi]

    cmp bl, 0
    je validDone

    cmp bl, '0'
    jb invalidNumber

    cmp bl, '9'
    ja invalidNumber

    inc esi
    jmp nextDigit

invalidNumber:
    xor eax, eax

validDone:
    ret

strLength:
    xor edx, edx

countLoop:
    cmp byte [esi+edx],0
    je finishCount

    inc edx
    jmp countLoop

finishCount:
    ret

section .data
newline db 10