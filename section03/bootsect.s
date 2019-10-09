org 0x7c00
;global _start

[section .data]


[section .text]

_start:
	mov ax, 0
	mov ss, ax
	mov sp, _stack_top
	mov ds, ax
	mov es, ax

	mov si, _msg
	mov cx, _msg_len

_print_msg:
	mov al, [ds:si]
	inc si

	mov ah, 0x0e
	mov bx, 15
	int 0x10
	loop _print_msg

_fin:
	hlt
	jmp _fin

_msg:
	db 0x0a, "Hello, world!", 0x0a
	_msg_len equ ($ - _msg)

_stack:
	times 128 db 0
	_stack_top equ ($)

_blank:
	times 0x1fe-($-$$) db 0
	db 0x55, 0xaa
