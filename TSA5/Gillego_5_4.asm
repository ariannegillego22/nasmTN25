
GLOBAL _start

SECTION .data
filename db "activity_5_4_output.txt", 0

file_msg db "Hello from Activity 5.4!", 10
file_msg_len equ $ - file_msg

screen_msg db "Message read from the file:", 10
screen_msg_len equ $ - screen_msg

SECTION .bss
file_descriptor resd 1
bytes_read resd 1
buffer resb 128

SECTION .text
_start:
    ; Create a file using sys_creat.
    mov eax, 8                 ; sys_creat
    mov ebx, filename
    mov ecx, 420               ; Decimal 420 = permission 0644
    int 0x80
    mov [file_descriptor], eax

    ; Write text into the newly created file.
    mov eax, 4                 ; sys_write
    mov ebx, [file_descriptor]
    mov ecx, file_msg
    mov edx, file_msg_len
    int 0x80

    ; Close the file after writing.
    mov eax, 6                 ; sys_close
    mov ebx, [file_descriptor]
    int 0x80

    ; Reopen the same file for reading.
    mov eax, 5                 ; sys_open
    mov ebx, filename
    mov ecx, 0                 ; O_RDONLY
    mov edx, 0
    int 0x80
    mov [file_descriptor], eax

    ; Read the file contents into the buffer.
    mov eax, 3                 ; sys_read
    mov ebx, [file_descriptor]
    mov ecx, buffer
    mov edx, 128
    int 0x80
    mov [bytes_read], eax

    ; Display a label on the screen.
    mov eax, 4
    mov ebx, 1
    mov ecx, screen_msg
    mov edx, screen_msg_len
    int 0x80

    ; Display the text read from the file.
    mov eax, 4                 ; sys_write
    mov ebx, 1                 ; Standard output
    mov ecx, buffer
    mov edx, [bytes_read]
    int 0x80

    ; Close the reopened file.
    mov eax, 6                 ; sys_close
    mov ebx, [file_descriptor]
    int 0x80

    ; Exit program.
    mov eax, 1
    xor ebx, ebx
    int 0x80