%include "../macro.inc"
global _start
extern float_to_str

section .data
num		dt 1.43225

section .bss
buffer	resb 32
buflen	equ $-buffer

section .text
_start:	fld tword [num]
		pcall float_to_str, buffer, buflen
		write 1, buffer, eax
		_exit 0
