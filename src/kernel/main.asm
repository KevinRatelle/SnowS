
org 0x7C00 ; OS at given adress
bits 16    ; historical reasons, but always start in 16 bit

; nasm macros
%define ENDL 0x0D, 0x0A

start:
	jmp main

;
puts:
	; save si and ax onto the stack
	push si
	push ax

.loop:
	lodsb ; loads next character in al
	or al,al ; check for null
	jz .done

	mov ah, 0x0E ; write char in TTY Mode
	;mov bh, 0
	int 0x10 ; interupt Video

	jmp .loop

.done:
	pop ax
	pop si
	ret

main:
	; setup data segments
	mov ax, 0
	mov ds, ax
	mov es, ax

	; setup stack
	mov ss, ax
	mov sp, 0x7C00 ; stack grows downwards

	; print dapne
	mov si, msg_dapne
	call puts

	hlt ; halt - does nothing

; make sure if the program continues it will continue halting
.halt:
	jmp .halt



; constants
msg_dapne:
	db 'Je taime Dapne.'
	db ENDL
	db 0x00


; AA55 are last 2 bytes of sector (expected by BIOS)
; will fill 510 bytes with 0s
times 510-($-$$) db 0
dw 0AA55h

