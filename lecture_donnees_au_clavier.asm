
; Pour executer ce code, vous devez utiliser l'assembleur NASM et le linker Golink
    ; la syntaxe est pour x86_64
        ; nasm -f win64 lecture_donnees_au_clavier.asm -o <prg>.obj
        ; golink <prg>.obj /entry main /console kernel32.dll

bits 64  

extern GetStdHandle
extern WriteConsoleA
extern ReadConsoleA
extern ExitProcess

STD_INPUT_HANDLE : equ -10
STD_OUTPUT_HANDLE : equ -11
MESSAGE_MAX_LENGTH : equ 255
SHADOWSPACE_SIZE : equ 32
NULL : equ 0

section .data
    message : db "Comment tu t'appelle ? "
    MESSAGE_LENGTH : equ $ - message

    pre : db "Bonjour "
    MESSAGE_LENGTH_PRE : equ $ - pre

section .bss
    written : resq 1
    written_pre : resq 1
    username : resq MESSAGE_MAX_LENGTH
    read : resq 4 

section .text
    global main
    main : 
        ; Demande de saisie
        ;--------------------------------------

        mov rcx, STD_OUTPUT_HANDLE
        call GetStdHandle

        sub rsp, SHADOWSPACE_SIZE
        sub rsp, 8

        mov rcx, rax
        mov rdx, message
        mov r8, MESSAGE_LENGTH
        mov r9, written
        mov qword[rsp+SHADOWSPACE_SIZE], NULL
        call WriteConsoleA

        ; Saisie au clavier
        ;--------------------------------------

        mov rcx, STD_INPUT_HANDLE
        call GetStdHandle

        sub rsp, SHADOWSPACE_SIZE
        sub rsp, 8

        mov rcx, rax
        mov rdx, username
        mov r8, MESSAGE_MAX_LENGTH
        mov r9, read
        mov qword[rsp+SHADOWSPACE_SIZE], NULL
        call ReadConsoleA

        ; Texte avant saisie
        ;--------------------------------------

        mov rcx, STD_OUTPUT_HANDLE
        call GetStdHandle

        sub rsp, SHADOWSPACE_SIZE
        sub rsp, 8

        mov rcx, rax
        mov rdx, pre
        mov r8, MESSAGE_LENGTH_PRE
        mov r9, written_pre
        mov qword[rsp+SHADOWSPACE_SIZE], NULL
        call WriteConsoleA

        ; Affichage de ce qu'on a saisie 
        ;--------------------------------------

        mov rcx, STD_OUTPUT_HANDLE
        call GetStdHandle

        sub rsp, SHADOWSPACE_SIZE
        sub rsp, 8

        mov rcx, rax
        mov rdx, username
        mov r8, MESSAGE_MAX_LENGTH
        mov r9, written
        mov qword[rsp+SHADOWSPACE_SIZE], NULL
        call WriteConsoleA

        ;Reinisialisation de la pile 
        ;--------------------------------------

        add rsp, SHADOWSPACE_SIZE+8

        ;Preparation de la sortie
        ;--------------------------------------

        xor ecx, ecx
        call ExitProcess