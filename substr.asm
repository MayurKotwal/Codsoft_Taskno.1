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
    msg1 db "Enter the first string (string1): ", 0
    len1 equ $ - msg1
    msg2 db "Enter the second string (string2): ", 0
    len2 equ $ - msg2
    msg11 db "String2 is a substring of String1.", 0
    len11 equ $ - msg11
    msg12 db "String2 is not a substring of String1.", 0
    len12 equ $ - msg12
    newline db 10, 0

section .bss
    string1 resb 100
    string2 resb 100
    l1 resq 1
    l2 resq 1

section .text
    global _start

_start:
    ; Prompt for and read the first string (string1)
    write msg1, len1
    read string1, 20
    dec rax
    mov [l1], rax ; Store length of string1

    ; Prompt for and read the second string (string2)
    write msg2, len2
    read string2, 20
    dec rax
    mov [l2], rax ; Store length of string2

    ; Check if string2 is a substring of string1
    mov rbx, [l2]      ; Load the length of string2
    mov rsi, string1    ; Start of string1
    mov rdi, string2    ; Start of string2

up3:
    mov al, byte [rsi]  ; Load the current character of string1
    cmp al, byte [rdi]  ; Compare it with the current character of string2
    je same             ; If they match, go to 'same'

    ; If not a match, reset rdi and start comparing from the next character of string1
    mov rdi, string2
    mov rbx, [l2]       ; Reset the length of string2
    inc rsi             ; Move to the next character in string1
    jmp up3

same:
    inc rsi             ; Move to the next character in string1
    inc rdi             ; Move to the next character in string2
    dec rbx             ; Decrease the length counter of string2
    dec qword [l1]      ; Decrease the length counter of string1
    cmp rbx, 0          ; Check if the entire string2 has been matched
    je st                ; If matched fully, print success message

    cmp qword [l1], 0    ; Check if the end of string1 is reached
    jne up3              ; If not, keep comparing

    ; If string2 is not a substring of string1
    write msg12, len12
    jmp exit

st:
    ; If string2 is a substring of string1
    write msg11, len11
    jmp exit

exit:
    ; Exit program
    mov rax, 60         ; Syscall to exit
    mov rdi, 00         ; Exit status
    syscall