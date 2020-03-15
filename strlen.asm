section .text
		global memchr
		global strlen

;==============================================================================
; strlen -> len of 0-terminated string
; in:
;     rdi - pointer to the string
;
; out:
;     rdx - len
;==============================================================================

strlen:
		mov rcx, 4096d
		mov rdx, rcx
		mov rax, 0
		
		call memchr
		
		ret

;==============================================================================
; memchr -> index of first occurence of char in str or -1 if not found
; in: 
;     rdi - pointer to the string
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
		mov rdx, 666d
		jmp .exit	

.found:
		sub rdx, rcx
		dec rdx
.exit:

		ret			

