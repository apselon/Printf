section .data
		string1 db 'I %s %x %d%%%c%b', 10d, 0
		string2 db 'love', 0 
section .text
		global _start
		extern _vprintf 

_start:
		push qword 127d
		push qword '!'
		push qword 100d
		push qword 3802d
		push string2
		mov rax, string1 
		call _vprintf 

		mov rax, 60d
		mov rdi, 0
		syscall

		ret
