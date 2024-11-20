%macro READ 2
mov rax,0
mov rdi,0
mov rsi,%1
mov rdx,%2
syscall
%endmacro

%macro WRITE 2
mov rax,1
mov rdi,1
mov rsi,%1
mov rdx,%2
syscall
%endmacro

%macro EXIT 0
mov rax, 60          ; Exit system call
mov rdi, 0           ; Exit status 0
syscall
%endmacro

section .data
msg1 db "Enter first number",10
len1 equ $-msg1
msg2 db "Enter second number",10
len2 equ $-msg2

section .bss
a resq 1
b resq 1
char_buff resb 16

section .text
global _start:
_start:

WRITE msg1,len1

READ char_buff,17

dec rax

mov rcx, rax

call accept
mov qword[a],rbx

WRITE msg2,len2
READ char_buff,17

dec rax

mov rcx,rax

call accept

mov qword[b],rbx
mov rbx,qword[a]

add rbx,qword[b]      ;add two numbers


call display

EXIT                    ; Call EXIT macro to exit the program

accept:
mov rsi,char_buff
mov rbx,00
up:mov rdx,00
mov dl,byte[rsi]
cmp dl,39H
jbe sub30
sub dl,07H

sub30:sub dl,30H
shl rbx,04
add rbx,rdx
inc rsi
dec rcx
jnz up
ret

display:
mov rcx,16
mov rsi, char_buff

up1:rol rbx,04
mov dl,bl
and dl,0FH
cmp dl,09h
jbe add30
add dl,07H

add30:add dl,30H
mov byte[rsi],dl
inc rsi
dec rcx
jnz up1
WRITE char_buff, 16
ret