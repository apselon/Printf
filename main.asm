%macro printf 1-*
	%rep %0 - 1
		%rotate -1
		push qword %1
	%endrep
	
	%rotate -1
	mov rax, %1
	call _vprintf

%endmacro


section .data
		string1 db 'I %s %x %d%%%c%b', 10d, 0
		string2 db 'love', 0 

section .text
		global _start
		extern _vprintf 

_start:

		printf string1, string2, 3802d, 100d, '!', 127d

		mov rax, 60d
		mov rdi, 0
		syscall

		ret
