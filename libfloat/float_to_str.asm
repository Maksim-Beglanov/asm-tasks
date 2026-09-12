%include "../macro.inc"
global float_to_str

section .data
basis 	dd 10

section .text
; void float_to_str(string* adress, int length)
; get float number from st0 and write it to adress fixed length with
; rounding. Return number of successed written chars
float_to_str:
		push ebp
		mov ebp, esp

		push esi					; esi carries adress of output
		mov esi, [ebp+8]
		push ebx
		xor ebx, ebx				; ebx carries current length

; copy byte from argument to output and compare number's length with
; maximum length for setting flags
%macro move_byte 1
		mov [esi+ebx], %1
		inc ebx
		cmp ebx, [ebp+12]
%endmacro

		sub esp, 4					; increase stack for buffer
		fstcw [esp]					; and set a rule don't round
		or word [esp], 0000110000000000b	; integer part of float
		fldcw [esp]					; numbers

		_fcom 0						; if it's not a zero
		jnz .not_zero				; skip it
		mov [esi], '0'				; else just save zero
		inc ebx
		jmp .finish

.not_zero:
		fild dword [basis]			; add basis to float stack for	
		fxch st1					; multiplying and dividing
		fld1						; add 1 for comparing
		fxch st1

		_fcom st1					; compare with 1 and if it's
		jb .mult_to_norm			; below, multiply it to normalize

		xor ecx, ecx				; else set pow of number to zero
		_fcom st2					; compare with 10 and if it's
		jae .div_to_norm			; above, divide it to normalize
		jmp .write_until_dot		; else write it until dot

.mult_to_norm:
		mov [esi+ebx], word '0.'	; add '0.' to the start
		add ebx, 2
		cmp ebx, [ebp+12]			; if size is greater than should,
		jae .number_is_too_long		; finish
		fmul st2					; else multiply by 10 and continue
.mult_loop:
		_fcom st1					; compare with 1, if it's greater,
		jae .write_after_dot		; write,
		fmul st2					; else multiply by 10 again
		move_byte '0'				; and add zero to output
		jae .finish					; if it's too long, finish
		jmp .mult_loop				; repeat

.div_to_norm:
		fdiv st2					; divide by 10 
		inc ecx						; increase pow
		_fcom st2					; compare with 10, if it's still
		jae .div_to_norm			; above, repeat
		jmp .write_until_dot		; else write it

; copy current integer part of normalized float number to output,
; then multiply it by 10 and set flags if number goes beyond the limits
%macro write_digit 0
		fist dword [esp]			; copy integer part to a buffer
		fisub dword [esp]			; and delete this from float
		fmul st2					; multiply by 10
		mov al, [esp]				; copy number to al
		add al, '0'					; make it number
		move_byte al				; and copy al to output
%endmacro

.write_until_dot:
		write_digit					; write digit
		jae .number_is_too_long		; if it's longer than borders, finish
		test ecx, ecx				; if pow is zero,
		jz .write_dot				; write dot,
		dec ecx						; else repeat
		jmp .write_until_dot
.write_dot:
		mov [esi+ebx], '.'
		inc ebx

.write_after_dot:
		write_digit					; write digit and if it's
		jae .finish					; longer than should, finish
		jmp .write_after_dot		; else repeat

.number_is_too_long:
		xor ebx, ebx
		mov [esi], 0
.finish:
		mov eax, ebx

		add esp, 4
		pop ebx
		pop esi
		mov esp, ebp
		pop ebp
		ret
