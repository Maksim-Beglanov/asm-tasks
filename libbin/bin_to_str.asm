global bin_to_str

section .text
; int bin_to_str(bin* adress, int len, string* adress)
; write a little endian binary data to a string in a hex format.
; Return a length of string
bin_to_str:
		push ebp
		mov ebp, esp
		push esi

		mov esi, [ebp+8]			; esi carries data adress
		mov eax, [ebp+12]			; eax carries count of bytes
		mov ecx, [ebp+16]			; ecx carries output adress

.lp:	test eax, eax				; if there's no bytes remain
		jz .lp_exit					; exit
		mov dl, [esi+eax-1]			; copy current byte to dl
		mov dh, dl					; separate first and last 4 bits
		and dl, 0x0F				; dl carries least 4 bits of byte
		shr dh, 4					; dh carries high 4 bits of byte

%macro copy_byte 1					; macro for writing one char from
		cmp %1, 10					; dl or dh. If it's less than 10
		jb %%decimal_digit			; write in decimal
		add %1, 'A'-10				; else turn into letter
		jmp %%copy_to_output		; and write
%%decimal_digit:
		add %1, '0'					; turn into decimal
%%copy_to_output:
		mov [ecx], %1				; write to output
		inc ecx						; and increase adress
%endmacro

		copy_byte dh				; write dh and then dl
		copy_byte dl
		dec eax						; move to the next byte
		jmp .lp
		
.lp_exit:
		mov eax, [ebp+12]			; calculate length of string
		shl eax, 1					; mult by 2

		pop esi
		mov esp, ebp
		pop ebp
		ret
