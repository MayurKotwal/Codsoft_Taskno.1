extern printf, scanf
%macro write 2
push rbp
mov rax,0
mov rdi,%1
mov rsi,%2
call printf
pop rbp
%endmacro
%macro scan 2
push rbp
mov rax,0
mov rdi,%1
mov rsi,%2
call scanf
pop rbp
%endmacro
%macro printfloat 2
push rbp
mov rax,1
mov rdi,%1
movsd xmm0,%2
call printf
pop rbp
%endmacro
section .data
m1 db "%lf",0
m2 db "%s",0
msg1 db "Enter the values of a, b, & c: ", 0
msg2 db "Roots are: "
msg3 db 10
section .bss
a resb 8
b resb 8
c resb 8
temp resw 1
t1 resb 8
t2 resb 8
t3 resb 8
t4 resb 8
r1 resb 10
r2 resb 10
section .text
global main
main:
write m2,msg1
scan m1,a
scan m1,b
scan m1,c
write m2,msg2
finit
fld qword[b]
fmul st0,st0 ;b*b
fstp qword[t1] ;t1=b^2
fld qword[a]
fmul qword[c]
mov word[temp],4
fimul word[temp]
fstp qword[t2] ;t2=4ac
fld qword[t1]
fsub qword[t2]
fstp qword[t4] ;t4=b^2-4ac
fld qword[t4]
fabs
fsqrt
fstp qword[t1] ;t1=root of b^2-4ac
fld qword[b]
fchs
fstp qword[t2]
fld qword[a]
mov qword[temp],02
fimul word[temp]
fstp qword[t3]
cmp qword[t4],0
je equal_root
fld qword[t2]
fadd qword[t1]
fdiv qword[t3]
fstp qword[r1]
printfloat m1,[r1]
equal_root:
fld qword[t2]
fsub qword[t1]
fdiv qword[t3]
fstp qword[r2]
printfloat m1,[r2]
write m2,msg3
mov rax,0
ret