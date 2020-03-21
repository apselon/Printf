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

;==============================================================================
; r8  - number of bits in one digit
; r9  - &-flag to extract $(r8) bits from number
; r10 - max result len
;==============================================================================
%macro set_convsersion 4
		mov r8,  %1	
		mov r9,  %2 
		mov r10, %3 
		jmp %4

%endmacro


section .data
		symbols db '0123456789ABCDEF', 0
		result times 2048 db 0


section .text
		global itoa
		global abs_val

;==============================================================================
; itoa -> 
; in:
;     rdi - num
;     rsi - base
; out:
;     rdi - ptr to the string
;==============================================================================

itoa:
		enter 0, 0
		pushaq

		std
		cmp rax, 10d
		je .decimal

		cmp rax, 2d
		je .bin

		cmp rax, 8d
		je .octal

		;cmp rsi, 16d
		jmp .hex


.bin:

		set_convsersion 1d, 0x01, 64d, .pow_2_conv

.hex:

		set_convsersion 4d, 0x0f, 16d, .pow_2_conv

.octal:

		set_convsersion 4d, 0x07, 21d, .pow_2_conv

.decimal:
		set_convsersion 10d,   0, 20d, .decimal_conv

.decimal_conv:
		dec r10

	;saving digit in rdx
		xor rdx, rdx			
		div r8 

	;saving in result ASCII code of digit 
		mov dl, byte [symbols + rdx]
		mov [result + r10], dl

		cmp r10, 0
		jne .decimal_conv

		jmp .exit

.pow_2_conv:
		dec r10
	
	;get current digit from number
		mov rdx, r9
		and dl, ax

	;save digit in result string
		mov dl, byte [rdx + symbols]
		mov [result + r10], dl

	;remove processed bits from number
		shr rax, cl

		cmp r10, 0
		jne .decimal_conv
		

.exit:
;todo fix padding
		popaq
		leave

		mov rdi, result
		ret


;==============================================================================
; abs:
; in:  rdi - num
; out: rdi - absolute value of num
;==============================================================================

abs_val:
		pushaq
		mov rax, rdi	

		cdq
		xor rax, rdx
		sub rax, rdx

		mov rdi, rax
		popaq
		ret 
