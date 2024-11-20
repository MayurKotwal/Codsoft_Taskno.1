%macro WRITE 02
mov rax ,1
mov rdi ,1
mov rsi ,%1
mov rdx ,%2
syscall
%endmacro

%macro READ 02
mov rax ,0
mov rdi ,0
mov rsi ,%1
mov rdx ,%2
syscall
%endmacro

section .data
msg1 db "Enter the BCD no. : ",10
len1 equ $-msg1
msg2 db "Hex equavalent is : ",10
len2 equ $-msg2
msg5 db "Wrong choice",10
len5 equ $-msg5
menu db 10,"* MENU *",10
     db"1.BCD to HEX",10
     db"2.Exit",10
     db"Enter your choice",10
menulen equ $-menu

section .bss
char_buff resb 17
ans resq 1
cnt resq 01
char resb 01
choice resb 02

section .text
global _start

_start:
	printmenu : WRITE menu,menulen
	   READ choice,02
	   cmp byte[choice],31H
	   je  BCDtoHEX
	    cmp byte[choice],32H
	    je exit
	    WRITE msg5,len5
	    jmp printmenu
	
	
mov rax,60
mov rdx,00
syscall

	

	
BCDtoHEX:
	WRITE msg1,len1
	READ char_buff,17
	dec rax
	mov rcx,rax
	mov rsi,char_buff
	mov rbx,00H
	up: mov rax,0AH
	mul rbx
	mov rbx,rax
	mov rdx,00H
	mov dl,byte[rsi]
	sub dl,30H
	add rbx,rdx
	inc rsi
	dec rcx
	jnz up
	
	mov[ans],rbx
	WRITE msg2,len2
	mov rbx,[ans]
	call display
	jmp _start
	
exit : mov rax,60
       mov rdi,00
       syscall	
       ret
       
accept: dec rax
	mov rcx,rax
	mov rsi,char_buff
	mov rbx,00H
up4:	
	shl rbx,04H
	mov rdx,00H
	mov dl,byte[rsi]
	cmp dl,39H
	jbe l1
	sub dl,07H
	l1:sub dl,30H
	add rbx,rdx
	inc rsi
	dec rcx
	jnz up4
	ret
display: mov rcx,16
	mov rsi,char_buff
up3:
	rol rbx,04H
	mov dl,bl
	and dl,0FH
	cmp dl,09H
	jbe l2
	add dl,07H
	l2:add dl,30H
	mov byte[rsi],dl
	inc rsi
	dec rcx
	jnz up3
	WRITE char_buff,16
	ret