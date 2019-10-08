;org 0x100
;global _start

[section .data]

_stack:
	times 128 db 0
_stack_top equ ($)

_msg:
	db "Hello, world!", 0
_msg_len equ ($ - _msg)

[section .text]

_start:
	mov ax, cs
	mov ss, ax
	mov sp, _stack_top

	mov ax, cs
	mov ds, ax
	mov si, _msg

	mov ax, 0xb800
	mov es, ax
	mov di, 0x0f00

	mov cx, _msg_len
	mov ah, 3

_show:
	mov al, [ds:si]
	mov [es:di], ax
	add si, 1
	add di, 2
	loop _show

_exit:
	mov ax, 0x4c00
	int 0x21


