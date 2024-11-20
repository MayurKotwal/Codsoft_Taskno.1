%macro read 2
    mov rax, 0          ; syscall for read
    mov rdi, 0          ; file descriptor for stdin
    mov rsi, %1         ; buffer to store input
    mov rdx, %2         ; number of bytes to read
    syscall
%endmacro

%macro write 2
    mov rax, 1          ; syscall for write
    mov rdi, 1          ; file descriptor for stdout
    mov rsi, %1         ; buffer to write
    mov rdx, %2         ; number of bytes to write
    syscall
%endmacro

section .data
    msg db "Enter a string to copy: ", 0
    len_msg equ $-msg

    result_msg db "The copied string is: ", 0
    len_result_msg equ $-result_msg

    newline db 10, 0

section .bss
    input resb 100       ; Input string buffer
    output resb 100      ; Output string buffer
    length resq 1        ; To store length of the string

section .text
    global _start

_start:
    ; Prompt user to enter a string
    write msg, len_msg
    read input, 100

                         ; Calculate string length excluding newline
    mov rsi, input       ; Pointer to the input string
    xor rcx, rcx         ; Initialize length counter
find_len:
    mov al, byte [rsi]   ; Load the current character
    cmp al, 0            ; Check for null terminator
    je store_length
    cmp al, 10           ; Check for newline
    je store_length
    inc rsi              ; Move to the next character
    inc rcx              ; Increment the counter
    jmp find_len

store_length:
    mov [length], rcx    ; Store the length in memory

    ; Copy string using rep movsb
    mov rsi, input       ; Source address
    mov rdi, output      ; Destination address
    mov rcx, rcx         ; Number of bytes to copy
    cld                  ; Clear direction flag
    rep movsb            ; Copy string byte by byte

    ; Print result message
    write result_msg, len_result_msg
    write output, rcx    ; Print the copied string

    ; Print newline
    write newline, 1

    ; Exit program
    mov rax, 60          ; syscall for exit
    xor rdi, rdi         ; exit code 0
    syscall