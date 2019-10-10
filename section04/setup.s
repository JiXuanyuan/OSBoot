;global _start

[section .text]

;//========================================================================

_start:
	mov ax, cs
	mov ss, ax
	mov sp, _stack_top
	mov ds, ax
	mov es, ax

	mov ax, _msg_hello
	call _func_print0

_fin:
	hlt
	jmp _fin

;//========================================================================
;// 显示字符串，以0结尾
;// ax = 字符串地址
_func_print0:
	mov si, ax
	mov ah, 0x0e
	mov bx, 15

_print0:
	mov al, [ds:si]
	inc si
	cmp al, 0
	je _print0_exit

	int 0x10
	jmp _print0

_print0_exit:
	ret

;//========================================================================

_msg_hello:
	db "Hello, setup!"
	db 0x0a, 0x0d, 0

;//========================================================================

_stack:
	times 128 db 0
_stack_top equ ($)

;//========================================================================

_blank:
	times (0x800 - ($ - $$)) db 0

;//========================================================================
