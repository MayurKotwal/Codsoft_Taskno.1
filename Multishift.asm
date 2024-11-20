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
num resb 17
ccnt resq 1
A resq 1
B resq 1
Q resq 1
n resq 1
buff resb 16

section .text
global _start



_start:
    ; Prompt for multiplicand
    write msg1, msg1_len
    read num, 17
    dec rax
    mov qword[ccnt], rax
    call accept
    mov qword[B], rbx

    ; Prompt for multiplier
    write msg2, msg2_len
    read num, 17
    dec rax
    mov qword[ccnt], rax
    call accept
    mov qword[Q], rbx

    ; Initialize values
    mov qword[A], 0      ; Accumulator
    mov qword[n], 64     ; 64-bit counter

above:
    mov rax, qword[Q]
    and rax, 01h         ; Check LSB of Q
    cmp rax, 01h
    jne shift
    mov rax, qword[A]
    mov rbx, qword[B]
    add rax, rbx         ; Add B to A
    mov qword[A], rax

shift:
    mov rax, qword[A]
    mov rbx, qword[Q]
    shr rbx, 1           ; Shift Q right by 1
    and rax, 1           ; Isolate LSB of A
    cmp rax, 1
    jne shift_a
    mov rdx, 1
    ror rdx, 1           ; Rotate right
    or rbx, rdx

shift_a:
    shr qword[A], 1      ; Shift A right by 1
    mov qword[Q], rbx
    dec qword[n]
    jnz above

    ; Display results
    write msg3, msg3_len
    mov rbx, qword[A]
    call disp
    mov rbx, qword[Q]
    call disp

    ; Exit program
    mov rax, 60          ; syscall: exit
    mov rdi, 0           ; exit status
    syscall

accept:
    mov rbx, 0
    mov rsi, num

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