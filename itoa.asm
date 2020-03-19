%macro pushaq 0
    push rax 
    push rcx 
    push rdx 
    push rbx 
    push rbp 
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
    	pop rbp 
    	pop rbx 
    	pop rdx 
    	pop rcx 
    	pop rax 
%endmacro

%macro set_convsersion 4
		mov r8, %1	
		mov r9, %2 
		add rcx, %3 
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
;    rdi - num
;    rsi - base
;==============================================================================

itoa:
		enter 0, 0
		pushaq

		std

		push rdi

		xor rcx, rcx

		cmp rsi, 10d
		je .decimal

		cmp rsi, 2d
		je .bin

		cmp rsi, 8d
		je .octal

		;cmp rsi, 16d
		je .hex


.bin:
	;	mov r8, 1d	
	;	mov r9, 0x01
	;	add rcx, 64d
	;	jmp .pow_2_conv

		set_convsersion 1d, 0x01, 64d, .pow_2_conv

.hex:
	;	mov r8, 4d
	;	mov r9, 0x0f
	;	add rcx, 16d
	;	jmp .pow_2_conv

		set_convsersion 4d, 0x0f, 16d, .pow_2_conv

.octal:
	;	mov r8, 3d
	;	mov r9, 0x07
	;	add rcx, 20d
	;	jmp .pow_2_conv

		set_convsersion 4d, 0x07, 21d, .pow_2_conv

.decimal:
		set_convsersion 10d,   0, 20d, .decimal_conv


.decimal_conv:
	;saving digit in rdx
		xor rdx, rdx			
		div r8 

	;saving in result ASCII code of digit 
		mov dl, byte [symbols + rdx]
		mov [result + rcx - 1], dl

		loop .decimal_conv

		jmp .exit

.pow_2_conv:
	;saving diggit in rdx
		mov rdx, r9
		and dl, al

	;saving in result ASCII code of digit 
		mov dl, byte [symbols + rdx]
		mov [result + rcx - 1], dl
	
	;removing translated digits
		mov r10, rcx
		mov rcx, r8
		shr rdi, cl
		mov rcx, r10

		loop .pow_2_conv
		
.exit:

		popaq
		leave

		push result
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
