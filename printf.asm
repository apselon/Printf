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
		extern put_char
		extern put_str
		extern put_num

		global _vprintf

;==============================================================================
; newest_trendiest_coolest_printf
; in: 
;     rax   - specificator string
;     stack - data to print
;==============================================================================

_vprintf:
		enter 0, 0
		pushaq
		
		add rbp, 16d

.string_view:
		cmp byte [rax], '%'
		jne .print_char

		inc rax
		jmp .process_spec
		
.print_char:
		mov rsi, [rax]
		call put_char

.continue:
		inc rax
		cmp byte [rax], 0
		jne .string_view

.exit:
		popaq
		leave
		ret

.process_spec:
		cmp byte [rax], 'c'	
		je .char

		cmp byte [rax], 'd'
		je .num_d

		cmp byte [rax], 'x'
		je .num_x

		cmp byte [rax], 'o'
		je .num_o

		cmp byte [rax], 'b'
		je .num_b

		cmp byte [rax], 's'
		je .str

		cmp byte [rax], '%'
		je .percent

		jmp .continue

.char:
		mov rsi, [rbp]
		call put_char
		add rbp, 8
		
		jmp .continue

.str:
		mov rsi, [rbp]
		call put_str
		add rbp, 8

		jmp .continue

.num_d:	
		mov r12, 10d
		jmp .num
.num_x:
		mov r12, 16d
		jmp .num
.num_o:
		mov r12, 8d
		jmp .num
.num_b:
		mov r12, 2d
		jmp .num

.num:
		push rax
		mov rax, [rbp]
		mov rsi, r12
		mov r11, 0
		call put_num
		pop rax

		add rbp, 8

		jmp .continue

.percent:
		mov rsi, '%' 
		call put_char

		jmp .continue
