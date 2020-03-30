;==============================================================================
; itoa 
; in:
;     rax - num
;     rsi - base
; 	  r11 - padding or 0 to minimal
; out:
;     rdi - ptr to the string
;==============================================================================
;==============================================================================
; abs
; in:  rdi - num
; out: rdi - absolute value of num
;==============================================================================
;==============================================================================
; set_padding
; in:
;     rdi - ptr to the string
;     r10 - current padding
;     r11 - wanted padding or 0 if minimal
; out:
;     rdi - moved ptr
;==============================================================================

%macro pushaq 0
	    push rax 
		push rcx 
    	push rdx 
	    push rbx 
	    push rbp 
	    push rsi 
	    push r8
	    push r9
%endmacro

%macro popaq 0
    	pop r9
		pop r8
    	pop rsi 
    	pop rbp 
    	pop rbx 
    	pop rdx 
    	pop rcx 
    	pop rax 
%endmacro

;==============================================================================
; r8  - number of bits in one digit
; r9  - &-flag to extract $(r8) bits from number
; r10 - max result len
;==============================================================================
%macro set_convsersion 4
		mov r8,  %1	
		mov r9,  %2 
		mov r10, %3 
		push r10
		jmp %4

%endmacro


section .data
		result times 2048d db 0
		symbols db '0123456789ABCDEF', 0


section .text
		global itoa
		global abs_val
		global set_padding

;==============================================================================
; itoa 
; in:
;     rax - num
;     rsi - base
; 	  r11 - padding or 0 to minimal
; out:
;     rdi - ptr to the string
;     r10 - num width 
;==============================================================================

itoa:
		enter 0, 0
		pushaq
		cld
		
		call clear_buff

		cmp rsi, 10d
		je .decimal

		cmp rsi, 2d
		je .bin

		cmp rsi, 8d
		je .octal

		cmp rsi, 16d
		je .hex

		jmp .exit


.bin:
		set_convsersion 1d, 0x01, 64d, .pow_2_conv
.octal:
		set_convsersion 3d, 0x07, 21d, .pow_2_conv
.hex:
		set_convsersion 4d, 0x0f, 16d, .pow_2_conv
.decimal:
		set_convsersion 10d,   0, 20d, .decimal_conv


.decimal_conv:
		dec r10

	;saving digit in rdx
		xor rdx, rdx			
		div r8 

	;save ASCII code of the digit in result string
		mov dl, byte [symbols + rdx]
		mov [result + r10], dl

		cmp r10, 0
		jne .decimal_conv

		jmp .exit


.pow_2_conv:
		dec r10
	
	;geteing current digit from number
		mov rdx, r9
		and dl, al

	;save ASCII code of the digit in result string
		mov dl, byte [symbols + rdx]
		mov [result + r10], dl

	;remove processed bits from number
		mov rcx, r8
		shr rax, cl

		cmp r10, 0
		jne .pow_2_conv		


.exit:

		pop r10
		popaq
		leave

		mov rdi, result

		call set_padding
		
		ret



;==============================================================================
; set_padding
; in:
;     rdi - ptr to the string
;     r10 - current padding
;     r11 - wanted padding or 0 if minimal
; out:
;     rdi - moved ptr
;==============================================================================

set_padding:
		enter 0, 0	
		pushaq

		cmp r11, 0
		je .minimal

.fixed:
		sub r10, r11	
		add rdi, r10
		jmp .exit

.minimal:
		mov rcx, r10
		cmp byte [rdi], '0'
		jne .exit

.crop:		
		inc rdi	

		cmp byte [rdi], '0'
		loope .crop

.exit:
		popaq
		leave
		ret



;==============================================================================
; abs:
; in:  rax - num
;==============================================================================

abs_val:
		cdq

		xor rax, rdx
		sub rax, rdx

		ret 


clear_buff:

		push rdi
		push rax
		push rcx
		

		xor rax, rax
		mov rcx, 100d
		mov rdi, result

		rep stosw

		pop rcx
		pop rax
		pop rdi

		ret

