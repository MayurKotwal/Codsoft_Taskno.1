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
    msg1 db "Enter the first string: ", 0
    len1 equ $ - msg1
    msg2 db "Enter the second string: ", 0
    len2 equ $ - msg2
    msg3 db "Comparing strings...", 0
    len3 equ $ - msg3
    msg4 db "Strings are equal.", 0
    len4 equ $ - msg4
    msg5 db "Strings are not equal.", 0
    len5 equ $ - msg5
    newline db 10, 0

section .bss
    string1 resb 100
    string2 resb 100
    l1 resq 1

section .text
    global _start

_start:
    ; Prompt for and read the first string
    write msg1, len1
    read string1, 100

    ; Prompt for and read the second string
    write msg2, len2
    read string2, 100

    ; Calculate the length of the first string
    mov rsi, string1
    xor rcx, rcx
find_len1:
    mov al, byte [rsi]
    cmp al, 0
    je store_len1
    inc rsi
    inc rcx
    jmp find_len1

store_len1:
    mov [l1], rcx  ; Store length of the first string

    ; Compare the lengths of both strings
    mov rbx, [l1]
    mov rsi, string2
    xor rcx, rcx
find_len2:
    mov al, byte [rsi]
    cmp al, 0
    je store_len2
    inc rsi
    inc rcx
    jmp find_len2

store_len2:
    ; If lengths are different, strings are not equal
    cmp rbx, rcx   ; Compare lengths of string1 and string2
    jne not_equal   ; If lengths are not equal, jump to not_equal

    ; If lengths are equal, compare the contents of the strings
    write msg3, len3  ; Inform user that comparison is happening
    mov rsi, string1  ; Source string
    mov rdi, string2  ; Destination string
    mov rcx, [l1]     ; Length of the strings
    cld               ; Clear direction flag (for incrementing)
    repe cmpsb        ; Compare bytes of the two strings
    jne not_equal     ; If strings are not equal, jump to not_equal

    ; If strings are equal
    write msg4, len4
    jmp _exit

not_equal:
    write msg5, len5  ; Strings are not equal
    jmp _exit

_exit:
    ; Print newline (optional, for better output formatting)
    write newline, 1

    ; Exit the program
    mov rax, 60         ; Exit syscall
    xor rdi, rdi        ; Exit code 0
    syscall