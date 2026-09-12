%include "../macro.inc"
global _start
extern int_to_str
extern str_to_int

section .data
end_line	db 10
end_linelen	equ $-end_line

section .bss
num		resb 11

section .text:
_start:	pcall int_to_str, 1432, num, 10	; int_to_str check
		write 1, num, eax				; save 1432 to num and print
		write 1, end_line, end_linelen

		cmp [esp], 2					; check turning number
		jne finish						; into string from arguments
		mov ebp, esp

		pcall str_to_int, [ebp+8], 16	; str_to_int check
		pcall int_to_str, eax, num, 16	; turn argument to string and
		write 1, num, eax				; integer back and forth
		write 1, end_line, end_linelen	; and print

finish:	_exit 0
