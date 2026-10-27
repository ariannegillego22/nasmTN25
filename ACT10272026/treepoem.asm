;MACRO- Sends the address of a line to the print_string procedure.
; %1 means the label passed to this macro, such as line1 or line2.
%macro PRINT_LINE 1
    mov ecx, %1
    call print_string
%endmacro

section .data
    line1   db "                         I", 10, 0
    line2   db "                       wrote", 10, 0
    line3   db "                      a poem", 10, 0
    line4   db "                    in the shape", 10, 0
    line5   db "                   of a Christmas", 10, 0
    line6   db "                 tree but then forgot", 10, 0
    line7   db "             to water it and only a few", 10, 0
    line8   db "                       days", 10, 0
    line9   db "                       later", 10, 0
    blank   db 10, 0
    line10  db "                       there", 10, 0
    line11  db "                 were              words", 10, 0
    line12  db "          all                 over", 10, 0
    line13  db "                 the                              carpet", 10, 0

section .text
    global _start               ;start of the program

_start:
    ;print every line
    PRINT_LINE line1
    PRINT_LINE line2
    PRINT_LINE line3
    PRINT_LINE line4
    PRINT_LINE line5
    PRINT_LINE line6
    PRINT_LINE line7
    PRINT_LINE line8
    PRINT_LINE line9
    PRINT_LINE blank
    PRINT_LINE line10
    PRINT_LINE line11
    PRINT_LINE line12
    PRINT_LINE line13

    ;exit the program
    mov eax, 1
    xor ebx, ebx
    int 0x80

; the procedure- to prints a null-terminated string.
; for input- ECX = address of string
print_string:
    push eax
    push ebx
    push ecx
    push edx

    mov edx, ecx

; to move through the string until the null terminator is found.
.find_end:
    cmp byte [edx], 0
    je .print
    inc edx
    jmp .find_end

.print:
    sub edx, ecx
    mov eax, 4
    mov ebx, 1
    int 0x80

    ;to restore the saved register values, then return to the macro call.
    pop edx
    pop ecx
    pop ebx
    pop eax
    ret