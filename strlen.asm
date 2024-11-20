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
    msg2 db "The length of the string is: ", 0
    len2 equ $ - msg2

section .bss
    string resb 20
    char_buff resb 16
    length resq 1

section .text
global _start

_start:
    ; Prompt for input
    write msg1, len1
    read string, 20

    ; Calculate string length
    mov rsi, string
    xor rcx, rcx          ; Counter for string length
find_len:
    mov al, byte [rsi]
    cmp al, 0             ; Check for null terminator
    je store_length
    inc rsi               ; Move to the next byte
    inc rcx               ; Increment counter
    jmp find_len

store_length:
    mov rbx, rcx          ; Store the length in rbx for display
    mov [length], rcx     ; Store the length in memory for other uses

    ; Print the result
    write msg2, len2
    call display          ; Call display to print the length

    ; Exit program
    mov rax, 60           ; Exit syscall
    xor rdi, rdi          ; Exit code 0
    syscall

display:
    mov rsi, char_buff    ; Start of char buffer
    mov rcx, 16           ; Buffer size
up2:
    rol rbx, 4            ; Rotate left to get the highest nibble
    mov dl, bl            ; Get the low byte
    and dl, 0x0F          ; Mask to get the last 4 bits
    cmp dl, 9             ; If 0-9
    jbe add30
    add dl, 7             ; Convert to A-F if > 9
add30:
    add dl, 48            ; Convert to ASCII
    mov byte [rsi], dl    ; Store in buffer
    inc rsi               ; Move buffer pointer
    dec rcx               ; Decrease buffer size
    jnz up2               ; Continue if buffer not full
    write char_buff, 16   ; Print the buffer
    ret