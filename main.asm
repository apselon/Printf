%macro case 2
		cmp [rsi], %1
		je %2
%endmacro

section .data

section .text
		extern put_char
		extern put_str
		extern put_num

		global newest_trendiest_coolest_printf
		global process_spec

;==============================================================================
; newest_trendiest_coolest_printf
; in: 
;     rsi   - specificator string
;     stack - data to print
;==============================================================================

newest_trendiest_coolest_printf:
		enter 0, 0
		pushaq

.string_view:
			cmp [rsi], '%'
			jne .print_char

			inc rsi
			jmp .process_spec
		
.print_char:
			push [rsi]
			call put_char
			pop [rsi]
.continue:
		inc rsi
		cmp [rsi], 0
		jne .string_view

.exit:
		popaq
		leave
		ret

.process_spec:
		case 'c' .char
		case 's' .string
		case 'd' .num_d
		case 'x' .num_x
		case 'o' .num_o
		case 'b' .num_b
		case '%' .percent

		jmp .continue

.char:
		call put_char
.str:
		call put_str
.num_d:	
.num_x:
.num_o:
.num_b:
.percent:

