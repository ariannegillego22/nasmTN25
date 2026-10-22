global _start
section .data
welcome db 10
       db "========================================",10
       db "        THE MYSTIC ZODIAC ORACLE",10
       db "========================================",10
       db "              *     *",10
       db "           *     /\     *",10
       db "                /  \",10
       db "               /____\",10
       db "                 ||",10
       db "           DISCOVER YOUR DESTINY!",10
       db "========================================",10
       db "       Fictional readings for fun.",10,10,0
name_prompt  db "Enter your name: ",0
month_prompt db "Enter birth month (1-12): ",0
day_prompt   db "Enter birth day (1-31): ",0
name_error db "Enter a nonblank name of up to 63 characters.",10,0
month_error db "Invalid month. Enter a number from 1 to 12.",10,0
date_error db "Invalid date for that month. Try again.",10
          db "February allows days 1-28.",10,0
hello db 10,"Welcome, ",0
exclamation db "!",10,0
newline db 10,0
zodiac_heading db 10
              db "========================================",10
              db "             YOUR ZODIAC SIGN",10
              db "========================================",10,0
sign_label db "Zodiac Sign: ",0
element_label db "Element: ",0
symbol_label db "Symbol: ",0
personality_label db "Personality: ",0
menu db 10
    db "============== HOROSCOPE MENU ==============",10
    db "[1] Love and Relationships",10
    db "[2] Career and Studies",10
    db "[3] Health and Wellness",10
    db "[4] Lucky Number and Color",10
    db "[5] View Zodiac Information",10
    db "[6] Exit",10
    db "Enter your choice: ",0
menu_error db "Invalid selection. Choose 1-6.",10,0
return_prompt db 10,"Return to menu? (Y/N): ",0
return_error db "Invalid answer. Enter Y or N.",10,0
love_title db 10,"LOVE AND RELATIONSHIPS",10,0
career_title db 10,"CAREER AND STUDIES",10,0
health_title db 10,"HEALTH AND WELLNESS",10,0
lucky_title db 10,"YOUR LUCKY NUMBER AND COLOR",10,0
love_text db ", a kind conversation may bring you closer",10
         db "to someone today. Listen carefully and",10
         db "show appreciation for the people you love.",10,0
career_text db ", your creativity may help you solve",10
           db "a difficult task today. Stay focused,",10
           db "manage your time, and trust your effort.",10,0
health_text db ", today may bring a chance to refresh",10
           db "your routine. Make time for rest,",10
           db "gentle movement, and a peaceful break.",10,0
goodbye db 10
       db "========================================",10
       db "       THANK YOU FOR VISITING!",10
       db "========================================",10,0
; Zodiac order:
; 0 Capricorn, 1 Aquarius, 2 Pisces, 3 Aries
; 4 Taurus, 5 Gemini, 6 Cancer, 7 Leo
; 8 Virgo, 9 Libra, 10 Scorpio, 11 Sagittarius
sign0  db "Capricorn",0
sign1  db "Aquarius",0
sign2  db "Pisces",0
sign3  db "Aries",0
sign4  db "Taurus",0
sign5  db "Gemini",0
sign6  db "Cancer",0
sign7  db "Leo",0
sign8  db "Virgo",0
sign9  db "Libra",0
sign10 db "Scorpio",0
sign11 db "Sagittarius",0
signs dd sign0, sign1, sign2, sign3
     dd sign4, sign5, sign6, sign7
     dd sign8, sign9, sign10, sign11
earth db "Earth",0
air   db "Air",0
water db "Water",0
fire  db "Fire",0
elements dd earth, air, water, fire
        dd earth, air, water, fire
        dd earth, air, water, fire
symbol0  db "Sea-Goat",0
symbol1  db "Water Bearer",0
symbol2  db "Fish",0
symbol3  db "Ram",0
symbol4  db "Bull",0
symbol5  db "Twins",0
symbol6  db "Crab",0
symbol7  db "Lion",0
symbol8  db "Maiden",0
symbol9  db "Scales",0
symbol10 db "Scorpion",0
symbol11 db "Archer",0
symbols dd symbol0, symbol1, symbol2, symbol3
       dd symbol4, symbol5, symbol6, symbol7
       dd symbol8, symbol9, symbol10, symbol11
trait0  db "Responsible, patient, ambitious.",0
trait1  db "Independent, inventive, friendly.",0
trait2  db "Caring, imaginative, gentle.",0
trait3  db "Brave, energetic, determined.",0
trait4  db "Reliable, practical, patient.",0
trait5  db "Curious, adaptable, expressive.",0
trait6  db "Loyal, caring, protective.",0
trait7  db "Confident, creative, courageous.",0
trait8  db "Organized, helpful, observant.",0
trait9  db "Fair, charming, cooperative.",0
trait10 db "Passionate, focused, resourceful.",0
trait11 db "Adventurous, honest, optimistic.",0
traits dd trait0, trait1, trait2, trait3
      dd trait4, trait5, trait6, trait7
      dd trait8, trait9, trait10, trait11
; Sign-specific ASCII designs.
art0 db "                 _",10
    db "         \      /_)",10
    db "          \    /`.   ",10
    db "           \  /   ;   ",10
    db "            \/ __.'  ;   ",10,0
    
art1 db "        WATER BEARER",10
    db "           .''-._.''-._.- ",10
    db "          .-''-._.''-._.-",10,0
    
art2 db "             `-.    .-'",10
     db "               :  :",10
     db "             --:--:--",10
     db "               :  :",10
     db "            .-'    `-.",10,0
    
art3 db "         .-.   .-. ",10
    db "        (_  \ /  _)",10
    db "             | ",10,
    db "             | ",10,0

art4 db "        .     .",10
    db "        '.___.'",10
    db "        .'   `.",10
    db "       :       :",10
    db "       :       :",10
    db "        `.___.'",10,0

art5 db "         ._____.",10
    db "           | |",10
    db "           | |",10
    db "          _|_|_",10
    db "         '     '",10,0

art6 db "         .--.",10
    db "        /   _`. ",10
    db "       (_) ( )",10
    db "      '.    /",10
    db "        `--'",10,0
    

art7 db "          .--.",10
    db "         (    )",10
    db "        (_)  /",10
    db "            (_,",10,0

art8 db "         _",10
    db "        ' `:--.--.",10
    db "           |  |  |_ ",10
    db "           |  |  | )",10
    db "           |  |  |/",10
    db "                (J",10,0

art9 db "         ____|____",10
    db "        /    |    \",10
    db "       (_)   |   (_)",10
    db "           __|__",10,0

art10 db "         _",10
     db "        ' `:--.--.",10
     db "           |  |  |",10
     db "           |  |  |",10
     db "           |  |  |  ..,",10
     db "                 `---':",10,0
    
art11 db "           ...",10
     db "           .':",10
     db "         .'",10
     db "     `..'",10
     db "     .'`.",10,0
    

arts dd art0, art1, art2, art3
    dd art4, art5, art6, art7
    dd art8, art9, art10, art11
lucky0  db "Lucky number: 8",10,"Lucky color: Brown",10,0
lucky1  db "Lucky number: 11",10,"Lucky color: Blue",10,0
lucky2  db "Lucky number: 7",10,"Lucky color: Sea Green",10,0
lucky3  db "Lucky number: 9",10,"Lucky color: Red",10,0
lucky4  db "Lucky number: 6",10,"Lucky color: Green",10,0
lucky5  db "Lucky number: 5",10,"Lucky color: Yellow",10,0
lucky6  db "Lucky number: 2",10,"Lucky color: Silver",10,0
lucky7  db "Lucky number: 1",10,"Lucky color: Gold",10,0
lucky8  db "Lucky number: 5",10,"Lucky color: Navy Blue",10,0
lucky9  db "Lucky number: 6",10,"Lucky color: Pink",10,0
lucky10 db "Lucky number: 9",10,"Lucky color: Maroon",10,0
lucky11 db "Lucky number: 3",10,"Lucky color: Purple",10,0
lucky_table dd lucky0, lucky1, lucky2, lucky3
           dd lucky4, lucky5, lucky6, lucky7
           dd lucky8, lucky9, lucky10, lucky11
; Maximum valid day for each month.
month_lengths dd 31,28,31,30,31,30,31,31,30,31,30,31
; Day when the next zodiac sign begins in each month.
start_days dd 20,19,21,20,21,21,23,23,23,23,22,22
section .bss
user_name resb 64
input_buffer resb 32
input_char resb 1
birth_month resd 1
birth_day resd 1
zodiac_index resd 1
too_long resb 1
section .text
_start:
   call display_welcome
   call get_user_info
   call determine_zodiac
   call display_zodiac_art
.menu_loop:
   call display_menu
   cmp eax, 1
   jl .invalid
   cmp eax, 6
   jg .invalid
   cmp eax, 6
   je .exit
   call show_horoscope
   call ask_return
   cmp eax, 1
   je .menu_loop
.exit:
   call exit_program
.invalid:
   mov ecx, menu_error
   call print_string
   jmp .menu_loop
; -------------------------------------------------
; Display the welcome screen.
; -------------------------------------------------
display_welcome:
   mov ecx, welcome
   call print_string
   ret
; -------------------------------------------------
; Read and validate the user's name and birth date.
; -------------------------------------------------
get_user_info:
.name:
   mov ecx, name_prompt
   call print_string
   mov ecx, user_name
   mov edx, 64
   call read_line
   cmp byte [too_long], 0
   jne .bad_name
   ; Require at least one non-whitespace character.
   mov esi, user_name
.check_name:
   mov al, [esi]
   cmp al, 0
   je .bad_name
   cmp al, 32
   ja .month
   inc esi
   jmp .check_name
.bad_name:
   mov ecx, name_error
   call print_string
   jmp .name
.month:
   mov ecx, month_prompt
   call print_string
   call read_number
   cmp eax, 1
   jl .bad_month
   cmp eax, 12
   jg .bad_month
   mov [birth_month], eax
   jmp .day
.bad_month:
   mov ecx, month_error
   call print_string
   jmp .month
.day:
   mov ecx, day_prompt
   call print_string
   call read_number
   mov [birth_day], eax
   call validate_birthdate
   cmp eax, 1
   jne .bad_day
   mov ecx, hello
   call print_string
   mov ecx, user_name
   call print_string
   mov ecx, exclamation
   call print_string
   ret
.bad_day:
   mov ecx, date_error
   call print_string
   jmp .day
; -------------------------------------------------
; Return EAX = 1 for a valid date, otherwise 0.
; February 29 is rejected because no year is entered.
; -------------------------------------------------
validate_birthdate:
   mov eax, [birth_month]
   cmp eax, 1
   jl .invalid
   cmp eax, 12
   jg .invalid
   dec eax
   mov edx, [month_lengths + eax*4]
   mov eax, [birth_day]
   cmp eax, 1
   jl .invalid
   cmp eax, edx
   jg .invalid
   mov eax, 1
   ret
.invalid:
   xor eax, eax
   ret
; -------------------------------------------------
; Determine the sign using the month and cutoff day.
; -------------------------------------------------
determine_zodiac:
   mov ebx, [birth_month]
   dec ebx
   mov eax, [birth_day]
   cmp eax, [start_days + ebx*4]
   jl .save
   inc ebx
   cmp ebx, 12
   jne .save
   xor ebx, ebx
.save:
   mov [zodiac_index], ebx
   ret
; -------------------------------------------------
; Display art, sign, element, symbol, personality.
; -------------------------------------------------
display_zodiac_art:
   mov ebx, [zodiac_index]
   mov ecx, zodiac_heading
   call print_string
   mov ecx, [arts + ebx*4]
   call print_string
   mov ecx, sign_label
   call print_string
   mov ecx, [signs + ebx*4]
   call print_string
   mov ecx, newline
   call print_string
   mov ecx, element_label
   call print_string
   mov ecx, [elements + ebx*4]
   call print_string
   mov ecx, newline
   call print_string
   mov ecx, symbol_label
   call print_string
   mov ecx, [symbols + ebx*4]
   call print_string
   mov ecx, newline
   call print_string
   mov ecx, personality_label
   call print_string
   mov ecx, [traits + ebx*4]
   call print_string
   mov ecx, newline
   call print_string
   ret
; -------------------------------------------------
; Display the menu and return the numeric choice.
; -------------------------------------------------
display_menu:
   mov ecx, menu
   call print_string
   call read_number
   ret
; -------------------------------------------------
; EAX contains the selected menu option.
; -------------------------------------------------
show_horoscope:
   cmp eax, 1
   je .love
   cmp eax, 2
   je .career
   cmp eax, 3
   je .health
   cmp eax, 4
   je .lucky
   cmp eax, 5
   je .information
   ret
.love:
   mov ecx, love_title
   call print_string
   call print_sign_name
   mov ecx, love_text
   call print_string
   ret
.career:
   mov ecx, career_title
   call print_string
   call print_sign_name
   mov ecx, career_text
   call print_string
   ret
.health:
   mov ecx, health_title
   call print_string
   call print_sign_name
   mov ecx, health_text
   call print_string
   ret
.lucky:
   mov ecx, lucky_title
   call print_string
   mov ebx, [zodiac_index]
   mov ecx, [lucky_table + ebx*4]
   call print_string
   ret
.information:
   call display_zodiac_art
   ret
; -------------------------------------------------
; Print the current zodiac sign.
; -------------------------------------------------
print_sign_name:
   mov ebx, [zodiac_index]
   mov ecx, [signs + ebx*4]
   call print_string
   ret
; -------------------------------------------------
; Return EAX = 1 for Y, or EAX = 0 for N.
; -------------------------------------------------
ask_return:
.retry:
   mov ecx, return_prompt
   call print_string
   mov ecx, input_buffer
   mov edx, 32
   call read_line
   cmp byte [too_long], 0
   jne .invalid
   cmp eax, 1
   jne .invalid
   mov al, [input_buffer]
   cmp al, 'Y'
   je .yes
   cmp al, 'y'
   je .yes
   cmp al, 'N'
   je .no
   cmp al, 'n'
   je .no
.invalid:
   mov ecx, return_error
   call print_string
   jmp .retry
.yes:
   mov eax, 1
   ret
.no:
   xor eax, eax
   ret
; -------------------------------------------------
; Read a number containing one or two ASCII digits.
; Return EAX = -1 if the input is invalid.
; -------------------------------------------------
read_number:
   mov ecx, input_buffer
   mov edx, 32
   call read_line
   cmp byte [too_long], 0
   jne .invalid
   cmp eax, 1
   jl .invalid
   cmp eax, 2
   jg .invalid
   mov esi, input_buffer
   xor eax, eax
.convert:
   movzx edx, byte [esi]
   cmp edx, 0
   je .done
   cmp edx, '0'
   jl .invalid
   cmp edx, '9'
   jg .invalid
   sub edx, '0'
   imul eax, eax, 10
   add eax, edx
   inc esi
   jmp .convert
.invalid:
   mov eax, -1
.done:
   ret
; -------------------------------------------------
; Print a zero-terminated string at ECX.
; Preserve all general-purpose registers.
; -------------------------------------------------
print_string:
   pushad
   xor edx, edx
.length:
   cmp byte [ecx + edx], 0
   je .write
   inc edx
   jmp .length
.write:
   mov eax, 4
   mov ebx, 1
   int 0x80
   popad
   ret
; -------------------------------------------------
; Read a complete input line.
;
; ECX = destination buffer
; EDX = buffer capacity, including the ending zero
; EAX = number of stored characters
;
; Reads one byte at a time so piped input also works.
; Excess characters are drained before returning.
; -------------------------------------------------
read_line:
   push ebx
   push esi
   push edi
   push ebp
   mov edi, ecx
   mov ebp, edx
   dec ebp
   xor esi, esi
   mov byte [too_long], 0
.read:
   mov eax, 3
   mov ebx, 0
   mov ecx, input_char
   mov edx, 1
   int 0x80
   ; Retry an interrupted system call.
   cmp eax, -4
   je .read
   cmp eax, 0
   jle .end_input
   mov al, [input_char]
   cmp al, 10
   je .finish
   ; Ignore carriage returns.
   cmp al, 13
   je .read
   ; Reject embedded zero bytes.
   cmp al, 0
   je .overflow
   cmp esi, ebp
   jae .overflow
   mov [edi + esi], al
   inc esi
   jmp .read
.overflow:
   mov byte [too_long], 1
   jmp .read
.finish:
   mov byte [edi + esi], 0
   mov eax, esi
   pop ebp
   pop edi
   pop esi
   pop ebx
   ret
.end_input:
   ; Process a final line without a newline.
   cmp esi, 0
   jne .finish
   call exit_program
; -------------------------------------------------
; Display goodbye and terminate the program.
; -------------------------------------------------
exit_program:
   mov ecx, goodbye
   call print_string
   mov eax, 1
   xor ebx, ebx
   int 0x80