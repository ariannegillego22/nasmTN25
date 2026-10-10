%define N       21              ; number of fields
%define BUFSZ   128             ; bytes per answer (127 chars + NUL)

%define C_PINK  27,"[1;35m"
%define C_YEL   27,"[1;33m"
%define C_CYAN  27,"[1;36m"
%define C_GRN   27,"[1;32m"
%define C_RED   27,"[1;31m"
%define C_RST   27,"[0m"

global _start

section .data

; ---------------- ASCII art banners ----------------

title_art:
    db 10, C_RED
    db " ____  _        _    __  __   ____   ___   ___  _  __",10
    db "/ ___|| |      / \  |  \/  | | __ ) / _ \ / _ \| |/ /",10
    db "\___ \| |     / _ \ | |\/| | |  _ \| | | | | | | ' / ",10
    db " ___) | |___ / ___ \| |  | | | |_) | |_| | |_| | . \ ",10
    db "|____/|_____/_/   \_\_|  |_| |____/ \___/ \___/|_|\_\",10
    db C_RST
    db "   Fill in the blanks and press ENTER after each one!",10,10,0

b_about:
    db C_PINK
    db " @@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@",10
    db "   .:*~*:._.:*~*:.   A B O U T   M E   .:*~*:._.:*~*:.",10
    db "                                        +-------------+",10
    db "      \|/                               |             |",10
    db "    --(*)--                             |    PHOTO    |",10
    db "      /|\                               |             |",10
    db "                                        |             |",10
    db "                                        +-------------+",10
    db " @@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@",10
    db C_RST,0

b_first:
    db 10, C_YEL
    db "        _..---.._",10
    db "      .'  _..._  '.",10
    db "     /  .'     '.  \",10
    db "    |  /         \  |      M Y   F I R S T . . .",10
    db "    | |           | |      -----------------------",10
    db C_RST,0

b_faves:
    db 10, C_CYAN
    db "  __  __ __   __   _____  _     __     __ _____ ____",10
    db " |  \/  |\ \ / /  |  ___|/ \    \ \   / /| ____/ ___|",10
    db " | |\/| | \ V /   | |_  / _ \    \ \ / / |  _| \___ \",10
    db " | |  | |  | |    |  _|/ ___ \    \ V /  | |___ ___) |",10
    db " |_|  |_|  |_|    |_| /_/   \_\    \_/   |_____|____/",10
    db "                                     .-------.",10
    db "                                    / o  o    \   <- palette",10
    db "                                   |   o   ()  |",10
    db "                                    \____/_____/",10
    db C_RST,0

b_perfume:
    db C_PINK
    db "        _",10
    db "       |_|          ~ ~",10
    db "     .-'-'-.       ~ ~ ~",10
    db "    /  ~~~  \    (perfume)",10
    db "    \_______/",10
    db C_RST,0

b_food:
    db 10, C_GRN
    db "   .-----.      _____       ___",10
    db "  (_______)    (_____)     /___\      F  O  O  D",10
    db "  (_______)    |_____|    (_____)      ~ yum! ~",10
    db C_RST,0

b_hobbies:
    db 10, C_YEL
    db "  +-----------------------------------+",10
    db "  |  /\_/\    H O B B I E S           |",10
    db "  | ( o.o )   ~ paint, play, create ~ |",10
    db "  |  > ^ <                            |",10
    db "  +-----------------------------------+",10
    db C_RST,0

b_ambition:
    db 10, C_RED
    db "    \o/  \o/  \o/  \o/  \o/  \o/  \o/",10
    db "     |    |    |    |    |    |    |",10
    db "    / \  / \  / \  / \  / \  / \  / \",10
    db "       A   M   B   I   T   I   O   N",10
    db C_RST,0

b_motto:
    db 10, C_CYAN
    db "         .-----------------------.",10
    db "        (    M   O   T   T   O     )",10
    db "         '-------.     .-----------'",10
    db "                  \   /",10
    db "                   \ /",10
    db "                    v",10
    db C_RST,0

; ---------------- Slam book complete banner ----------------

done_art:
    db 10, C_PINK
    db " =====================================================",10
    db "   *  *  *   Y O U R   S L A M   B O O K   *  *  *",10
    db " =====================================================",10
    db C_RST,10,0

bye_art:
    db 10, C_PINK
    db "        .-.   .-.",10
    db "       (   `-'   )      Thanks for signing my slam book!",10
    db "        `.     .'       Stay awesome!  <3",10
    db "          `. .'",10
    db "            `",10
    db C_RST,10,0

; ---------------- Prompts ----------------

p_name:     db C_RST,"  Name: ",0
p_email:    db "  Email: ",0
p_blog:     db "  Blog/Website: ",0
p_ach:      db "  First big achievement: ",0
p_risk:     db "  First risk I ever took: ",0
p_happy:    db "  First time I felt completely happy: ",0
p_color:    db "  Color(s): ",0
p_perfume:  db "  Perfume: ",0
p_music:    db "  Music: ",0
p_singer:   db "  Singer(s): ",0
p_song:     db "  Song: ",0
p_food:     db "  Food: ",0
p_weekend:  db "  Weekend activity: ",0
p_hobbies:  db "  Hobbies: ",0
p_tv:       db "  TV Show: ",0
p_movie:    db "  Movie: ",0
p_book:     db "  Book: ",0
p_celebs:   db "  Celebs: ",0
p_role:     db "  Role model: ",0
p_ambition: db "  Ambition: ",0
p_motto:    db "  Motto: ",0

ans_on:     db C_CYAN,0
ans_off:    db C_RST,10,0

; ---------------- Field table: [banner or 0, prompt] ----------------

align 4
fields:
    dd b_about,   p_name
    dd 0,         p_email
    dd 0,         p_blog
    dd b_first,   p_ach
    dd 0,         p_risk
    dd 0,         p_happy
    dd b_faves,   p_color
    dd b_perfume, p_perfume
    dd 0,         p_music
    dd 0,         p_singer
    dd 0,         p_song
    dd b_food,    p_food
    dd b_hobbies, p_weekend
    dd 0,         p_hobbies
    dd 0,         p_tv
    dd 0,         p_movie
    dd 0,         p_book
    dd 0,         p_celebs
    dd 0,         p_role
    dd b_ambition,p_ambition
    dd b_motto,   p_motto

section .bss
answers: resb N*BUFSZ

section .text

_start:
    mov ecx, title_art
    call puts

    ; pass 1: ask every question ----------
    xor esi, esi                    ; i = 0
.ask:
    cmp esi, N
    jae .show

    lea edi, [fields + esi*8]       ; edi -> table entry

    mov ecx, [edi]                  ; banner?
    test ecx, ecx
    jz .no_banner
    call puts
.no_banner:
    mov ecx, [edi+4]                ; prompt
    call puts

    mov eax, esi
    imul eax, BUFSZ
    add eax, answers
    mov ecx, eax
    call read_line

    inc esi
    jmp .ask

    ; pass 2: print the finished slam book ----------
.show:
    mov ecx, done_art
    call puts

    xor esi, esi
.out:
    cmp esi, N
    jae .finish

    lea edi, [fields + esi*8]

    mov ecx, [edi]
    test ecx, ecx
    jz .no_banner2
    call puts
.no_banner2:
    mov ecx, [edi+4]                ; prompt text doubles as label
    call puts

    mov ecx, ans_on
    call puts

    mov eax, esi
    imul eax, BUFSZ
    add eax, answers
    mov ecx, eax
    call puts                       ; the user's answer

    mov ecx, ans_off
    call puts

    inc esi
    jmp .out

.finish:
    mov ecx, bye_art
    call puts

    mov eax, 1                      ; sys_exit
    xor ebx, ebx
    int 0x80

; ----------------------------------------------------------
; puts: print NUL-terminated string at ecx to stdout
; ----------------------------------------------------------
puts:
    push ebx
    xor edx, edx
.len:
    cmp byte [ecx+edx], 0
    je .write
    inc edx
    jmp .len
.write:
    mov eax, 4                      ; sys_write
    mov ebx, 1                      ; stdout
    int 0x80
    pop ebx
    ret

; ----------------------------------------------------------
; read_line: read a line from stdin into buffer at ecx
;            strips newline, NUL-terminates, discards overflow
; ----------------------------------------------------------
read_line:
    push ebx
    push ecx
    mov eax, 3                      ; sys_read
    xor ebx, ebx                    ; stdin
    mov edx, BUFSZ-1
    int 0x80
    pop ecx

    test eax, eax
    jle .empty                      ; EOF or error -> empty answer

    cmp byte [ecx+eax-1], 10
    jne .no_nl
    dec eax                         ; drop the newline
    mov byte [ecx+eax], 0
    jmp .ret

.no_nl:
    mov byte [ecx+eax], 0
    cmp eax, BUFSZ-1
    jne .ret                        ; short line, EOF

.drain:                             ; line too long: eat the rest of it
    push 0
    mov eax, 3
    xor ebx, ebx
    mov ecx, esp
    mov edx, 1
    int 0x80
    cmp eax, 1
    jne .drain_done
    cmp byte [esp], 10
    jne .drain_more
.drain_done:
    add esp, 4
    jmp .ret
.drain_more:
    add esp, 4
    jmp .drain

.empty:
    mov byte [ecx], 0
.ret:
    pop ebx
    ret