org 0x100

[section .data]

_msg:
	db 0x0a, "Hello, world!", 0x0a
_msg_len equ ($ - _msg)

_blank:
	times (_msg_len) db 0

[section .text]

_start:
	mov ax, cs
	mov ds, ax
	mov es, ax

	mov si, _msg
	mov di, _blank
	mov cx, _msg_len
	cld
	rep movsb
	