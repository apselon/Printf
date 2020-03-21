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
%endmacro

%macro popaq 0
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

		global put_num
		global _start

;==============================================================================
; put_num
; in:
;    stack - num
;    rsi   - base
; out:
; 	 rdi   - num
;    num in stdout
;==============================================================================

put_num:

		enter 0, 0
		pushaq

	;converting num to string
		mov rax, [rbp + 16]
		call itoa

	;writing string
		push rdi
		call put_str

		popaq
		leave		
		ret
