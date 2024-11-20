%macro read 2
    mov rax, 0
    mov rdi, 0
    mov rsi, %1
    mov rdx, %2
    syscall
%endmacro

%macro write 2
    mov rax, 1
    mov rdi, 1
    mov rsi, %1
    mov rdx, %2
    syscall
%endmacro

section .data
    msg1 db "Enter a string: ", 0
    len1 equ $ - msg1
    msg9 db "The string is a palindrome.", 0
    len9 equ $ - msg9
    msg10 db "The string is not a palindrome.", 0
    len10 equ $ - msg10
    newline db 10, 0

section .bss
    string1 resb 100
    string3 resb 100
    l1 resq 1

section .text
    global _start

_start:
    ; Prompt for and read the input string
    write msg1, len1
    read string1, 20

    ; Calculate the length of the input string (string1)
    mov rsi, string1
    xor rcx, rcx
find_len:
    mov al, byte [rsi]
    cmp al, 0
    je store_len
    inc rsi
    inc rcx
    jmp find_len

store_len:
    mov [l1], rcx  ; Store length of string1

    ; Reverse string1 and store in string3
    mov rsi, string1
    add rsi, [l1]  ; Move rsi to the end of string1
    dec rsi         ; Adjust to point to the last character
    mov rdi, string3
    mov rcx, [l1]   ; Length of string1
reverse:
    mov dl, byte [rsi]  ; Load byte from string1
    mov byte [rdi], dl  ; Store byte in string3
    dec rsi             ; Move to the previous character of string1
    inc rdi             ; Move to the next character in string3
    dec rcx             ; Decrease length counter
    jnz reverse         ; Repeat until the entire string is reversed

    ; Compare string1 and string3 (the reversed string)
    mov rsi, string1
    mov rdi, string3
    mov rcx, [l1]       ; Length of the string
    cld                 ; Clear the direction flag
    repe cmpsb          ; Compare the two strings byte by byte
    jne not_palindrome  ; Jump if strings are not equal

    ; If strings are equal, print palindrome message
    write msg9, len9
    jmp printmenu

not_palindrome:
    ; If strings are not equal, print non-palindrome message
    write msg10, len10

printmenu:
    ; Exit the program
    mov rax, 60         ; Exit syscall
    xor rdi, rdi        ; Exit code 0
    syscall

