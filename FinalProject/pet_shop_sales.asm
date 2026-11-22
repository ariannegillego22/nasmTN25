; ================================================================
; PET PARADISE SALES SYSTEM
; NASM 32-bit / Linux (uses int 80h system calls)
;
; Build:
; nasm -f elf32 pet_shop_sales.asm -o pet_shop_sales.o
; ld -m elf_i386 pet_shop_sales.o -o pet_shop_sales
; ./pet_shop_sales
; ================================================================

%define SYS_EXIT    1
%define SYS_READ    3
%define SYS_WRITE   4
%define SYS_OPEN    5
%define SYS_CLOSE   6

%define STDIN       0
%define STDOUT      1

%define O_RDONLY    0
%define O_WRONLY    1
%define O_CREAT     64
%define O_TRUNC     512
%define FILE_FLAGS  577
%define FILE_MODE   420

; -------------------- MACROS --------------------

%macro PRINT 2
    mov eax, SYS_WRITE
    mov ebx, STDOUT
    mov ecx, %1
    mov edx, %2
    int 80h
%endmacro

%macro WRITE_FILE 2
    mov eax, SYS_WRITE
    mov ebx, [receipt_fd]
    mov ecx, %1
    mov edx, %2
    int 80h
%endmacro

%macro NEW_LINE 0
    PRINT newline, 1
%endmacro


section .data

title           db 10
                db "  +=================================================+",10
                db "  ||             PET SALES SYSTEM                  ||",10
                db "  ||       Pets, Paws, and Happy Tails!            ||",10
                db "  +=================================================+",10,
title_len       equ $ - title

pet_art         db "  +-------------------------------------------------+",10
                db "  |  /",92,"_/",92,"   /",92,"_/",92,"   /",92,"_/",92,"          / ",92,"__          |",10
                db "  | ( o.o ) ( o.o ) ( o.o )        (    @",92,"___      | ",10
                db "  |  > ^ <   > ^ <   > ^ <         /         O     |",10
                db "  | ( o.o ) ( o.o ) ( o.o )        /   (_____ /    |",10
                db "  |  > ^ <   > ^ <   > ^ <        /_____/   U      |",10
                db "  +-------------------------------------------------+",10,10
pet_art_len     equ $ - pet_art

menu            db "  +================= PET SHOP MENU =================+",10
                db "  | 1. Dog Food (1kg)        - PHP 150             |",10
                db "  | 2. Cat Food (1kg)        - PHP 130             |",10
                db "  | 3. Pet Shampoo           - PHP 120             |",10
                db "  | 4. Chew Toy              - PHP  80             |",10
                db "  | 5. Cat Litter (5L)       - PHP 180             |",10
                db "  | 6. Pet Collar            - PHP 100             |",10
                db "  | 7. Pet Treats            - PHP  60             |",10
                db "  | 8. Cat Bed               - PHP 350             |",10
                db "  | 9. Checkout                                    |",10
                db "  +=================================================+",10
menu_len        equ $ - menu

current_total_msg db 10,"  >>> Current Total Purchased: PHP "
current_total_len equ $ - current_total_msg

amount_due_msg  db 10,"  >>> Amount to Pay: PHP "
amount_due_len  equ $ - amount_due_msg

choose_msg      db "  Enter your choice (1-9): "
choose_len      equ $ - choose_msg

qty_msg         db 10,"  Enter quantity: "
qty_len         equ $ - qty_msg

added_msg       db 10,"  + Item added to cart successfully!",10,10
added_len       equ $ - added_msg

continue_msg    db "  Do you want to continue shopping?",10
                db "  1. Yes - Add another item",10
                db "  2. No  - Proceed to checkout",10
                db "  Choose: "
continue_len    equ $ - continue_msg

continue_invalid_msg db 10,"  Invalid choice. Please enter 1 or 2.",10,10
continue_invalid_len equ $ - continue_invalid_msg

invalid_quantity_msg db 10,"  Invalid quantity. Enter a whole number greater than 0.",10,10
invalid_quantity_len equ $ - invalid_quantity_msg

invalid_member_msg db 10,"  Invalid member choice. Please enter 1 or 2.",10,10
invalid_member_len equ $ - invalid_member_msg

invalid_payment_msg db 10,"  Invalid payment. Enter an amount greater than 0.",10,10
invalid_payment_len equ $ - invalid_payment_msg

invalid_msg     db 10,"  Invalid choice. Please choose 1 to 9.",10,10
invalid_len     equ $ - invalid_msg

no_items_msg    db 10,"  Your cart is empty. Add an item first.",10,10
no_items_len    equ $ - no_items_msg

member_msg      db 10,"  Are you a member? (1 = Yes, 2 = No): "
member_len      equ $ - member_msg

payment_msg     db 10,"  Enter payment amount: PHP "
payment_len     equ $ - payment_msg

not_enough_msg  db 10,"  Insufficient payment. Please enter enough cash.",10,10
not_enough_len  equ $ - not_enough_msg

file_error_msg  db 10,"  ERROR: Cannot open or read receipt.txt.",10
file_error_len  equ $ - file_error_msg

processing_msg  db 10,"Processing transaction...",10
processing_len  equ $ - processing_msg

receipt_msg     db 10,"Receipt saved as receipt.txt",10
receipt_len     equ $ - receipt_msg

show_receipt    db "Here is your receipt:",10
show_receipt_len equ $ - show_receipt

thanks_msg      db 10,"Thank you for shopping at Pet Paradise!",10
thanks_len      equ $ - thanks_msg

receipt_file    db "receipt.txt",0

receipt_head    db "PET PARADISE - OFFICIAL RECEIPT",10
                db "================================",10
                db "ITEMS PURCHASED",10
receipt_head_len equ $ - receipt_head

receipt_line     db "--------------------------------",10
receipt_line_len equ $ - receipt_line

receipt_x        db " x "
receipt_x_len    equ $ - receipt_x

receipt_php      db " - PHP "
receipt_php_len  equ $ - receipt_php

label_subtotal   db "Subtotal: PHP "
label_subtotal_len equ $ - label_subtotal

label_discount   db "Member Discount (10%): PHP "
label_discount_len equ $ - label_discount

label_total      db "TOTAL: PHP "
label_total_len  equ $ - label_total

label_payment    db "Payment: PHP "
label_payment_len equ $ - label_payment

label_change     db "Change: PHP "
label_change_len equ $ - label_change

receipt_thanks   db "Thank you! Please come again.",10
receipt_thanks_len equ $ - receipt_thanks

newline          db 10

dog_food        db "Dog Food (1kg)"
dog_food_len    equ $ - dog_food

cat_food        db "Cat Food (1kg)"
cat_food_len    equ $ - cat_food

shampoo         db "Pet Shampoo"
shampoo_len     equ $ - shampoo

chew_toy        db "Chew Toy"
chew_toy_len    equ $ - chew_toy

cat_litter      db "Cat Litter (5L)"
cat_litter_len  equ $ - cat_litter

pet_collar      db "Pet Collar"
pet_collar_len  equ $ - pet_collar

pet_treats      db "Pet Treats"
pet_treats_len  equ $ - pet_treats

cat_bed         db "Cat Bed"
cat_bed_len     equ $ - cat_bed


section .bss

input_buffer      resb 32
number_buffer     resb 16
receipt_buffer    resb 2048

receipt_fd        resd 1
subtotal          resd 1
discount          resd 1
total             resd 1
payment           resd 1
change            resd 1
quantity          resd 1
item_total        resd 1
item_count        resd 1
selected_price    resd 1
selected_name     resd 1
selected_name_len resd 1


section .text
global _start

_start:

    mov dword [subtotal], 0
    mov dword [discount], 0
    mov dword [item_count], 0

    call open_receipt_for_write
    WRITE_FILE receipt_head, receipt_head_len


main_menu:

    PRINT title, title_len
    PRINT pet_art, pet_art_len
    PRINT menu, menu_len

    call show_current_total

    PRINT choose_msg, choose_len
    call get_number

    cmp eax, 1
    je choose_dog_food

    cmp eax, 2
    je choose_cat_food

    cmp eax, 3
    je choose_shampoo

    cmp eax, 4
    je choose_chew_toy

    cmp eax, 5
    je choose_cat_litter

    cmp eax, 6
    je choose_pet_collar

    cmp eax, 7
    je choose_pet_treats

    cmp eax, 8
    je choose_cat_bed

    cmp eax, 9
    je checkout

    PRINT invalid_msg, invalid_len
    jmp main_menu


choose_dog_food:

    mov dword [selected_price], 150
    mov dword [selected_name], dog_food
    mov dword [selected_name_len], dog_food_len
    jmp ask_quantity


choose_cat_food:

    mov dword [selected_price], 130
    mov dword [selected_name], cat_food
    mov dword [selected_name_len], cat_food_len
    jmp ask_quantity


choose_shampoo:

    mov dword [selected_price], 120
    mov dword [selected_name], shampoo
    mov dword [selected_name_len], shampoo_len
    jmp ask_quantity


choose_chew_toy:

    mov dword [selected_price], 80
    mov dword [selected_name], chew_toy
    mov dword [selected_name_len], chew_toy_len
    jmp ask_quantity


choose_cat_litter:

    mov dword [selected_price], 180
    mov dword [selected_name], cat_litter
    mov dword [selected_name_len], cat_litter_len
    jmp ask_quantity


choose_pet_collar:

    mov dword [selected_price], 100
    mov dword [selected_name], pet_collar
    mov dword [selected_name_len], pet_collar_len
    jmp ask_quantity


choose_pet_treats:

    mov dword [selected_price], 60
    mov dword [selected_name], pet_treats
    mov dword [selected_name_len], pet_treats_len
    jmp ask_quantity


choose_cat_bed:

    mov dword [selected_price], 350
    mov dword [selected_name], cat_bed
    mov dword [selected_name_len], cat_bed_len


ask_quantity:

    PRINT qty_msg, qty_len
    call get_number

    cmp eax, 0
    jle invalid_quantity

    mov [quantity], eax

    mov ebx, [selected_price]
    mul ebx

    mov [item_total], eax
    add [subtotal], eax

    inc dword [item_count]

    call write_item
    PRINT added_msg, added_len


ask_continue:

    PRINT continue_msg, continue_len
    call get_number

    cmp eax, 1
    je main_menu

    cmp eax, 2
    je checkout

    PRINT continue_invalid_msg, continue_invalid_len
    jmp ask_continue


invalid_quantity:

    PRINT invalid_quantity_msg, invalid_quantity_len
    jmp ask_quantity


checkout:

    cmp dword [item_count], 0
    je empty_cart

    call show_current_total


ask_member:

    PRINT member_msg, member_len
    call get_number

    cmp eax, 1
    je member_discount

    cmp eax, 2
    je no_member_discount

    PRINT invalid_member_msg, invalid_member_len
    jmp ask_member


member_discount:

    mov eax, [subtotal]
    xor edx, edx
    mov ebx, 10
    div ebx

    mov [discount], eax
    jmp compute_total


no_member_discount:

    mov dword [discount], 0


compute_total:

    mov eax, [subtotal]
    sub eax, [discount]

    mov [total], eax

    call show_amount_due


ask_payment:

    PRINT payment_msg, payment_len
    call get_number

    mov [payment], eax

    cmp eax, 0
    jle invalid_payment

    cmp eax, [total]
    jl insufficient_payment

    sub eax, [total]
    mov [change], eax

    jmp finish_receipt


insufficient_payment:

    PRINT not_enough_msg, not_enough_len
    jmp ask_payment


invalid_payment:

    PRINT invalid_payment_msg, invalid_payment_len
    jmp ask_payment


empty_cart:

    PRINT no_items_msg, no_items_len
    jmp main_menu


finish_receipt:

    PRINT processing_msg, processing_len

    call write_summary

    mov eax, SYS_CLOSE
    mov ebx, [receipt_fd]
    int 80h

    PRINT receipt_msg, receipt_len
    PRINT show_receipt, show_receipt_len

    call read_and_show_receipt

    PRINT thanks_msg, thanks_len

    mov eax, SYS_EXIT
    xor ebx, ebx
    int 80h


; -------------------- PROCEDURES --------------------


open_receipt_for_write:

    mov eax, SYS_OPEN
    mov ebx, receipt_file
    mov ecx, FILE_FLAGS
    mov edx, FILE_MODE
    int 80h

    test eax, eax
    js file_error_exit

    mov [receipt_fd], eax
    ret


get_number:

    mov eax, SYS_READ
    mov ebx, STDIN
    mov ecx, input_buffer
    mov edx, 31
    int 80h

    cmp eax, 0
    jle .input_failed

    mov byte [input_buffer + eax], 0

    mov esi, input_buffer
    call ascii_to_number

    ret

.input_failed:

    xor eax, eax
    ret


ascii_to_number:

    xor eax, eax

.next_char:

    movzx ebx, byte [esi]

    cmp bl, '0'
    jb .done

    cmp bl, '9'
    ja .done

    imul eax, eax, 10

    sub ebx, '0'
    add eax, ebx

    inc esi
    jmp .next_char

.done:

    ret


number_to_string:

    mov edi, number_buffer + 15
    mov byte [edi], 0

    mov ebx, 10
    xor esi, esi

    cmp eax, 0
    jne .convert

    dec edi
    mov byte [edi], '0'

    mov ecx, edi
    mov edx, 1

    ret

.convert:

    xor edx, edx
    div ebx

    add dl, '0'

    dec edi
    mov [edi], dl

    inc esi

    test eax, eax
    jnz .convert

    mov ecx, edi
    mov edx, esi

    ret


show_current_total:

    PRINT current_total_msg, current_total_len

    mov eax, [subtotal]
    call number_to_string

    PRINT ecx, edx
    NEW_LINE
    NEW_LINE

    ret


show_amount_due:

    PRINT amount_due_msg, amount_due_len

    mov eax, [total]
    call number_to_string

    PRINT ecx, edx
    NEW_LINE
    NEW_LINE

    ret


write_item:

    pushad

    mov ecx, [selected_name]
    mov edx, [selected_name_len]
    WRITE_FILE ecx, edx

    WRITE_FILE receipt_x, receipt_x_len

    mov eax, [quantity]
    call number_to_string
    WRITE_FILE ecx, edx

    WRITE_FILE receipt_php, receipt_php_len

    mov eax, [item_total]
    call number_to_string
    WRITE_FILE ecx, edx

    WRITE_FILE newline, 1

    popad
    ret


write_summary:

    WRITE_FILE receipt_line, receipt_line_len

    WRITE_FILE label_subtotal, label_subtotal_len

    mov eax, [subtotal]
    call number_to_string
    WRITE_FILE ecx, edx
    WRITE_FILE newline, 1

    WRITE_FILE label_discount, label_discount_len

    mov eax, [discount]
    call number_to_string
    WRITE_FILE ecx, edx
    WRITE_FILE newline, 1

    WRITE_FILE label_total, label_total_len

    mov eax, [total]
    call number_to_string
    WRITE_FILE ecx, edx
    WRITE_FILE newline, 1

    WRITE_FILE label_payment, label_payment_len

    mov eax, [payment]
    call number_to_string
    WRITE_FILE ecx, edx
    WRITE_FILE newline, 1

    WRITE_FILE label_change, label_change_len

    mov eax, [change]
    call number_to_string
    WRITE_FILE ecx, edx
    WRITE_FILE newline, 1

    WRITE_FILE receipt_line, receipt_line_len
    WRITE_FILE receipt_thanks, receipt_thanks_len

    ret


read_and_show_receipt:

    mov eax, SYS_OPEN
    mov ebx, receipt_file
    mov ecx, O_RDONLY
    xor edx, edx
    int 80h

    test eax, eax
    js file_error_exit

    mov [receipt_fd], eax

    mov eax, SYS_READ
    mov ebx, [receipt_fd]
    mov ecx, receipt_buffer
    mov edx, 2048
    int 80h

    test eax, eax
    js file_error_exit

    mov esi, eax

    mov eax, SYS_CLOSE
    mov ebx, [receipt_fd]
    int 80h

    mov eax, SYS_WRITE
    mov ebx, STDOUT
    mov ecx, receipt_buffer
    mov edx, esi
    int 80h

    ret


file_error_exit:

    PRINT file_error_msg, file_error_len

    mov eax, SYS_EXIT
    mov ebx, 1
    int 80h