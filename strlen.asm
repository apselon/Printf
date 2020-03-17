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


section .text
		global memchr
		global strlen

;==============================================================================
; strlen -> len of 0-terminated string
; in:
;     rsi - pointer to the string
;
; out:
;     rdx - len
;==============================================================================

strlen:
		push rdi
		push rsi
		
		mov rcx, 4096d
		mov rdx, rcx
		mov rax, 0

		mov rdi, rsi
		call memchr
		
		pop rsi
		pop rdi
		
		ret

;==============================================================================
; memchr -> index of first occurence of char in str or -1 if not found
; in: 
;     rsi - pointer to the string
;     rcx - string len
;     rax - char to find
;
; out:
;     rdx - index of occurence
;==============================================================================
memchr:	
		cld

		repne scasb
		jz .found	

.not_found:
		mov rdx, -1d
		jmp .exit	

.found:
		sub rdx, rcx
		dec rdx
.exit:

		ret			

