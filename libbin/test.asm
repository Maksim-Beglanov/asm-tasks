%include "../macro.inc"
extern bin_to_str
global _start

section .data
num 	dt 2.0
num_len equ $-num

section .bss
buffer resb 64

section .text
_start:	pcall bin_to_str, num, num_len, buffer	; try to print num
		write 1, buffer, eax					; write from buffer
		_exit 0
