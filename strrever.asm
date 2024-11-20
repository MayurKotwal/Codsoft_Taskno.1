%macro read 2
    mov rax, 0          ; Syscall number for read
    mov rdi, 0          ; File descriptor (0 for stdin)
    mov rsi, %1         ; Address of buffer
    mov rdx, %2         ; Number of bytes to read
    syscall             ; Make the syscall
%endmacro

%macro write 2
    mov rax, 1          ; Syscall number for write
    mov rdi, 1          ; File descriptor (1 for stdout)
    mov rsi, %1         ; Address of buffer
    mov rdx, %2         ; Number of bytes to write
    syscall             ; Make the syscall
%endmacro

section .data
    msg db "Enter a string to reverse: ", 0
    len_msg equ $-msg

    result_msg db "The reversed string is: ", 0
    len_result_msg equ $-result_msg

    newline db 10, 0

section .bss
    string1 resb 100      ; Buffer to hold input string
    string3 resb 100      ; Buffer to hold reversed string

section .text
    global _start

_start:
    ; Prompt the user for input
    write msg, len_msg
    read string1, 100

    ; Store the length of the string in rcx
    mov rsi, string1
    xor rcx, rcx          ; Reset counter
find_len:
    mov al, byte [rsi]
    cmp al, 0
    je store_length
    inc rsi
    inc rcx
    jmp find_len

store_length:
    mov rbx, rcx          ; Store string length in rbx

    ; Reverse the string
    mov rsi, string1      ; Point to the end of string1
    add rsi, rbx          ; Move to the last character
    dec rsi               ; Adjust to point to the last valid character
    mov rdi, string3      ; Point to the start of string3
    mov rcx, rbx          ; Length of string to reverse
reverse_loop:
    mov bl, byte [rsi]    ; Load byte from string1
    mov byte [rdi], bl    ; Store byte in string3
    dec rsi               ; Move backwards in string1
    inc rdi               ; Move forwards in string3
    dec rcx               ; Decrement length counter
    jnz reverse_loop      ; Continue loop if there are still bytes to reverse

    ; Print the result message
    write result_msg, len_result_msg
    write string3, rbx    ; Write the reversed string

    ; Exit
    mov rax, 60           ; Exit syscall
    xor rdi, rdi          ; Exit code 0
    syscall