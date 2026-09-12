global int_to_str

section .text
; int int_to_str(int number, string *adress, int basis)
; Write number to adress in given basis. Return count of success
; written chars.
int_to_str:
		push ebp
		mov ebp, esp
		push esi
		mov esi, [ebp+12]

		mov eax, [ebp+8]			; eax carries number
		xor edx, edx				; clear edx for division
		xor ecx, ecx				; ecx carries count of chars

.lp:	xor edx, edx				; clear edx for division
		div dword [ebp+16]			; divide eax by basis
		push edx					; push remainder to stack
		inc ecx						; increase count of digits
		test eax, eax				; if number is over,
		jz .lp_exit					; exit from loop
		jmp .lp						; else repeat
.lp_exit:
		xor eax, eax				; clear eax for return value
									; it'll carries output
.write_lp:
		cmp eax, ecx				; if there remains no digits
		jae .finish					; finish
		pop edx						; else pop another one
		cmp edx, 10					; if it's less than 10
		jb .add_decimal_digit		; print usual decimals
		add edx, 'A'-10				; else turn number into letter
		jmp .write					; and write it
.add_decimal_digit:
		add edx, '0'				; if it's decimal number, add '0'
.write:	mov [esi+eax], edx
		inc eax						; increase length of output
		jmp .write_lp
		
.finish:
		pop esi
		mov esp, ebp
		pop ebp
		ret
