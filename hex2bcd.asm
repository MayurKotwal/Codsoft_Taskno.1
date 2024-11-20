%macro WRITE 2
    mov rax, 1        ; Syscall: write
    mov rdi, 1        ; File descriptor: stdout
    mov rsi, %1       ; Buffer to write from
    mov rdx, %2       ; Number of bytes to write
    syscall
%endmacro

%macro READ 2
    mov rax, 0        ; Syscall: read
    mov rdi, 0        ; File descriptor: stdin
    mov rsi, %1       ; Buffer to read into
    mov rdx, %2       ; Number of bytes to read
    syscall
%endmacro

section .data
msg3 db "Enter the HEX number: ", 10
len3 equ $ - msg3
msg4 db "BCD equivalent is: ", 10
len4 equ $ - msg4

section .bss
char_buff resb 17      ; Buffer for hexadecimal input
ans resq 1             ; Holds converted number
cnt resb 1             ; Digit count for BCD conversion
char resb 1            ; Temporary storage for characters

section .text
global _start

_start:
    WRITE msg3, len3   ; Prompt for hexadecimal input
    READ char_buff, 17 ; Read input string
    call accept        ; Convert hex to binary (stored in rbx)

                       ; Convert binary to BCD
    mov byte [cnt], 0  ; Reset digit count
    mov rax, rbx       ; Copy binary number to rax
up1:
    xor rdx, rdx       ; Clear remainder
    mov rbx, 10        ; Divisor (decimal base)
    div rbx            ; Divide rax by 10
    push rdx           ; Push remainder (digit)
    inc byte [cnt]     ; Increment digit count
    test rax, rax      ; Check if rax is 0
    jne up1            ; Repeat until quotient is 0

    WRITE msg4, len4   ; Print the result message

                       ; Display BCD digits
up2:
    pop rdx            ; Pop the next digit
    add dl, 48         ; Convert to ASCII
    mov byte [char], dl
    WRITE char, 1      ; Print the digit
    dec byte [cnt]     ; Decrement digit count
    jnz up2            ; Repeat until all digits are printed

    ; End the program
    mov rax, 60        ; Syscall: exit
    xor rdi, rdi       ; Exit code 0
    syscall

                       ; Function to convert hexadecimal string                        ;to binary
accept:
    dec rax            ; Exclude newline from input length
    mov rcx, rax       ; Length of input
    mov rsi, char_buff ; Input string pointer
    xor rbx, rbx       ; Clear rbx (result)

up4:
    shl rbx, 4         ; Shift result left by 4 bits
    xor rdx, rdx       ; Clear rdx (temporary for conversion)
    mov dl, byte [rsi] ; Load current character
    cmp dl, '9'        ; Check if character is <= '9'
    jbe l1
    sub dl, 7          ; Adjust for 'A'-'F'
l1:
    sub dl, 48         ; Convert ASCII to binary
    add rbx, rdx       ; Add to result
    inc rsi            ; Advance to next character
    dec rcx            ; Decrement loop counter
    jnz up4            ; Repeat until all characters are processed
    ret