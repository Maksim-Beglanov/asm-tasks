%include "../macro.inc"
global str_to_int

section .text
; int str_to_int(string *adress, int basis) 
; read number from adress in given basis until finds zero byte
str_to_int:
		push ebp
		mov ebp, esp
		mov ecx, [ebp+8]			; ecx carries adress of string
		xor eax, eax				; eax carries return value
		xor edx, edx				; edx is a value of current char

.read_lp:
		cmp [ecx], 0				; if it's zero byte,
		je .finish					; finish
		mul dword [ebp+12]			; else add new register to eax

		xor edx, edx				; and calc value of new digit
		mov dl, [ecx]
		cmp dl, '9'
		jbe .add_decimal_digit
		sub dl, 'A'-10
		jmp .add_digit
.add_decimal_digit:
		sub dl, '0'
.add_digit:
		add eax, edx
		inc ecx
		jmp .read_lp

.finish:
		mov esp, ebp
		pop ebp
		ret
