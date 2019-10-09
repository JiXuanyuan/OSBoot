
INT_FUNC_TYPE equ 0x7c

[section .data]

_stack:
	times 128 db 0
_stack_top equ ($)

_msg:
	db "This is a demo.", 0
_msg_len equ ($ - _msg)

[section .text]

_start:
	mov ax, cs
	mov ss, ax
	mov sp, _stack_top

	mov ax, cs
	mov bx, _msg
	mov cx, _msg_len
	int INT_FUNC_TYPE

_exit:
	mov ax, 0x4c00
	int 0x21