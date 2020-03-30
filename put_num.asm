%macro pushaq 0
    push rax
    push rcx
    push rdx
    push rbx
    push rbp
    push rdi
    push rsi
    push r8
    push r9
    push r10
	push r11
%endmacro

%macro popaq 0
		pop r11
        pop r10
        pop r9
        pop r8
        pop rsi
        pop rdi
        pop rbp
        pop rbx
        pop rdx
        pop rcx
        pop rax
%endmacro

section .data

section .text
		extern itoa
		extern put_str
		extern put_char

		global put_num

;==============================================================================
; put_num
; in:
;    rax - num
;    rsi - base
;    r11 - padding or 0 if minimal
; out:
;    num in stdout
;==============================================================================
	
put_num:

		enter 0, 0
		pushaq

	;converting num to string
		cmp rax, 0	
		jge .positive
		
		push rsi
		mov rsi, '-'
		call put_char
		pop rsi

		neg rax
		
.positive:
		call itoa

	;writing string
		mov rsi, rdi
		call put_str

		popaq
		leave
		ret

