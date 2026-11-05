global _start

; MACROS

; Display a message on the screen.
%macro PRINT 1
   pushad
   mov ebx, 1
   mov ecx, %1
   mov edx, %1_len
   call write_all
   popad
%endmacro
; Write a message to receipt.txt.
%macro SAVE 1
   mov ebx, [receipt_fd]
   mov ecx, %1
   mov edx, %1_len
   call write_all
%endmacro

; DATA SECTION

section .data
   filename db 'receipt.txt', 0
   menu db 10
        db '+------------- Georgette EATERY -------------+', 10
        db 'A. Rice: Plain Rice             Php 5.00', 10
        db 'B. Rice: Java Rice              Php 10.00', 10
        db 'C. Ulam 1: Fish                 Php 35.00', 10
        db 'D. Ulam 2: Pork                 Php 50.00', 10
        db 'E. Ulam 3: Vegetables           Php 20.00', 10
        db 'F. Dessert: Saging con yelo     Php 60.00', 10
        db '+-------------------------------------------+', 10
   menu_len equ $ - menu
   prompt db 'Enter your order [A-F]: '
   prompt_len equ $ - prompt
   ordered db 'You ordered '
   ordered_len equ $ - ordered
   again db 'Do you want to order again? [Y/N]: '
   again_len equ $ - again
   invalid_order db 'Invalid choice. Enter one letter from A to F.', 10
   invalid_order_len equ $ - invalid_order
   invalid_again db 'Invalid answer. Enter Y or N.', 10
   invalid_again_len equ $ - invalid_again
   thanks db 10, 'Thank you! Please come again!', 10, 10
   thanks_len equ $ - thanks
   heading db '-------------------------------------------',10
           db 'Georgette Eatery - Receipt', 10
           db '-------------------------------------------', 10
   heading_len equ $ - heading
   item_a db 'Plain Rice: Php 5.00', 10
   item_a_len equ $ - item_a
   item_b db 'Java Rice: Php 10.00', 10
   item_b_len equ $ - item_b
   item_c db 'Fish: Php 35.00', 10
   item_c_len equ $ - item_c
   item_d db 'Pork: Php 50.00', 10
   item_d_len equ $ - item_d
   item_e db 'Vegetables: Php 20.00', 10
   item_e_len equ $ - item_e
   item_f db 'Saging con yelo: Php 60.00', 10
   item_f_len equ $ - item_f

   ; Addresses of the six item messages.

   items dd item_a, item_b, item_c
         dd item_d, item_e, item_f

   ; Lengths of the six item messages.
   lengths dd item_a_len, item_b_len, item_c_len
           dd item_d_len, item_e_len, item_f_len

   error_msg db 'Error: unable to complete input/output.', 10
   error_msg_len equ $ - error_msg
   receipt_fd dd -1

; UNINITIALIZED VARIABLES

section .bss
   input_byte resb 1
   first_char resb 1
   receipt_buffer resb 1024

; MAIN PROGRAM

section .text
_start:
   call create_receipt
order_loop:
   call display_menu
   call read_choice
   ; End gracefully if input ends.
   cmp eax, -1
   je finish
   ; Accept choices A to F.
   cmp eax, 'A'
   jb bad_order
   cmp eax, 'F'
   ja bad_order
   ; Convert A-F to an index from 0-5.
   sub eax, 'A'
   call process_order
ask_again:
   PRINT again
   call read_choice
   cmp eax, -1
   je finish
   cmp eax, 'Y'
   je order_loop
   cmp eax, 'N'
   je finish
   PRINT invalid_again
   jmp ask_again
bad_order:
   PRINT invalid_order
   jmp order_loop
finish:
   call close_receipt
   PRINT thanks
   ; Reopen and display the saved receipt.
   call display_receipt
   mov eax, 1
   xor ebx, ebx
   int 0x80

; PROCEDURE: CREATE RECEIPT
; to creates a new receipt for each program run.

create_receipt:
   mov eax, 5                  ; sys_open
   mov ebx, filename
   mov ecx, 577                ; Write + create + truncate
   mov edx, 0o644              ; File permissions
   int 0x80
   test eax, eax
   js io_error
   mov [receipt_fd], eax
   SAVE heading
   ret

; PROCEDURE: DISPLAY MENU

display_menu:
   PRINT menu
   PRINT prompt
   ret

; PROCEDURE: READ CHOICE
;
; it reads a complete input line.
; Returns:

read_choice:
   xor esi, esi
.read:
   mov eax, 3                  ; sys_read
   xor ebx, ebx                ; Standard input
   mov ecx, input_byte
   mov edx, 1
   int 0x80
   ; Retry an interrupted read.
   cmp eax, -4
   je .read
   test eax, eax
   js io_error
   jz .eof
   mov al, [input_byte]
   ; Enter ends the input line.
   cmp al, 10
   je .done
   ; Ignore carriage return for CRLF input.
   cmp al, 13
   je .read
   test esi, esi
   jnz .extra
   mov [first_char], al
   mov esi, 1
   jmp .read
.extra:
   ; Multiple characters make the input invalid.
   ; Continue reading to consume the entire line.
   mov esi, 2
   jmp .read
.eof:
   test esi, esi
   jnz .done
   mov eax, -1
   ret
.done:
   xor eax, eax
   cmp esi, 1
   jne .return
   mov al, [first_char]
   ; Convert lowercase letters to uppercase.
   cmp al, 'a'
   jb .return
   cmp al, 'z'
   ja .return
   sub al, 32
.return:
   ret

; PROCEDURE: PROCESS ORDER
; the EAX contains the selected item index, 0-5 and displays and saves the selected item.

process_order:
   mov esi, [items + eax * 4]
   mov edi, [lengths + eax * 4]
   PRINT ordered
   ; Display the selected item and price.
   mov ebx, 1
   mov ecx, esi
   mov edx, edi
   call write_all
   ; Save the selected item and price.
   mov ebx, [receipt_fd]
   mov ecx, esi
   mov edx, edi
   call write_all
   ret

; PROCEDURE: WRITE ALL
; it headingandles partial writes.

write_all:
   test edx, edx
   jz .done
.write:
   mov eax, 4                  ; sys_write
   int 0x80
   cmp eax, -4
   je .write
   test eax, eax
   jle io_error
   add ecx, eax
   sub edx, eax
   jnz .write
.done:
   ret

; PROCEDURE: CLOSE RECEIPT

close_receipt:
   mov eax, 6                  ; sys_close
   mov ebx, [receipt_fd]
   int 0x80
   mov dword [receipt_fd], -1
   test eax, eax
   js io_error
   ret

; PROCEDURE: DISPLAY RECEIPT
; Reads the actual contents of receipt.txt.

display_receipt:
   mov eax, 5                  ; sys_open
   mov ebx, filename
   xor ecx, ecx                ; Read-only
   int 0x80
   test eax, eax
   js io_error
   mov [receipt_fd], eax
.read:
   mov eax, 3                  ; sys_read
   mov ebx, [receipt_fd]
   mov ecx, receipt_buffer
   mov edx, 1024
   int 0x80
   cmp eax, -4
   je .read
   test eax, eax
   js io_error
   jz .done
   ; Display the bytes read from the file.
   mov edx, eax
   mov ebx, 1
   mov ecx, receipt_buffer
   call write_all
   jmp .read
.done:
   call close_receipt
   ret

; ERROR HANDLER

io_error:
   mov eax, 4
   mov ebx, 2                  ; Standard error
   mov ecx, error_msg
   mov edx, error_msg_len
   int 0x80
   mov ebx, [receipt_fd]
   cmp ebx, 0
   jl .exit
   mov eax, 6
   int 0x80
.exit:
   mov eax, 1
   mov ebx, 1
   int 0x80