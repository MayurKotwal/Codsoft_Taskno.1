; Macros for system calls
%macro write 2
    mov rax, 1          ; syscall: write
    mov rdi, 1          ; file descriptor: stdout
    mov rsi, %1         ; message address
    mov rdx, %2         ; message length
    syscall
%endmacro

%macro read 2
    mov rax, 0          ; syscall: read
    mov rdi, 0          ; file descriptor: stdin
    mov rsi, %1         ; buffer address
    mov rdx, %2         ; buffer size
    syscall
%endmacro

section .data
msg1 db "Enter the multiplicand: ", 10
msg1_len equ $-msg1
msg2 db "Enter the multiplier: ", 10
msg2_len equ $-msg2
msg3 db "Multiplication Result: ", 10
msg3_len equ $-msg3

section .bss
ccnt resq 1
no1 resq 1
no2 resq 1
buff resb 16

section .text
global _start

_start:
    ; Prompt for multiplicand
    write msg1, msg1_len
    read buff, 17
    dec rax
    mov qword[ccnt], rax
    call accept
    mov qword[no1], rbx

    ; Prompt for multiplier
    write msg2, msg2_len
    read buff, 17
    dec rax
    mov qword[ccnt], rax
    call accept
    mov qword[no2], rbx

    ; Initialize result
    mov rbx, 0

l1:
    add rbx, qword[no1] ; Add multiplicand to result
    dec qword[no2]      ; Decrement multiplier
    cmp qword[no2], 0   ; Check if multiplier is zero
    jne l1

    ; Display result
    write msg3, msg3_len
    call disp

    ; Exit program
    mov rax, 60         ; syscall: exit
    mov rdi, 0          ; exit status
    syscall

accept:
    mov rbx, 0
    mov rsi, buff

up1:
    mov rdx, 0
    mov dl, byte[rsi]
    cmp dl, 39h
    jbe sub_30
    sub dl, 7
sub_30:
    sub dl, 30h
    shl rbx, 4
    add rbx, rdx
    inc rsi
    dec qword[ccnt]
    jnz up1
    ret

disp:
    mov rsi, buff
    mov rcx, 16
    mov rdx, 0
up2:
    rol rbx, 4
    mov dl, bl
    and dl, 0Fh
    cmp dl, 9
    jbe mc
    add dl, 7h
mc:
    add dl, 30h
    mov [rsi], dl
    inc rsi
    dec rcx
    jnz up2
    write buff, 16
    ret