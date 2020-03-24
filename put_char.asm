%macro pushaq 0
    push rax
    push rcx
    push rdx
    push rbx
    push rbp
    push rsi
    push rdi
	push r8
	push r9
	push r10
%endmacro

%macro popaq 0
	pop r10
	pop r9
	pop r8
    pop rdi    
    pop rsi    
    pop rbp    
    pop rbx    
    pop rdx    
    pop rcx
    pop rax
%endmacro

section .data
	cur_char db 0

section .text
		stdout_f equ 1d

		global put_char		

;==============================================================================
; put_char.
; in: 
;    rsi - char to print
;==============================================================================
put_char:
		enter 0, 0	
		pushaq

	;save argument from stack
		mov r8, rsi 
		mov byte [cur_char], r8b

	;write char;
		mov rax, 1d
		mov rdx, 1d
		mov rdi, stdout_f
		mov rsi, cur_char
		syscall

		popaq
		leave
		ret	
