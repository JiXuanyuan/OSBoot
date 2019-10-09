;org 0x100

INT_FUNC_ADDR equ 0x07e0
INT_FUNC_TYPE equ 0x7c

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

	call _copy_int_func
	call _set_int_tab

	mov ax, cs
	mov bx, _msg
	mov cx, _msg_len
	int INT_FUNC_TYPE

_exit:
	mov ax, 0x4c00
	int 0x21

;================================
_copy_int_func:
	mov ax, cs
	mov ds, ax
	mov ax, INT_FUNC_ADDR
	mov es, ax
	
	mov si, _int_func
	mov di, 0
	mov cx, _int_func_len

	cld
	rep movsb

	ret

;================================
_set_int_tab:
	cli

	mov ax, 0
	mov es, ax

	mov word [es:(INT_FUNC_TYPE * 4)], 0
	mov word [es:(INT_FUNC_TYPE * 4 + 2)], INT_FUNC_ADDR

	sti
	ret

;================================
_int_func:
	push ds
	push es
	push si
	push di
	push ax
	push bx
	push cx

	mov ds, ax
	mov si, bx

	mov ax, 0xb800
	mov es, ax
	mov di, 0x0f00

	;mov cx, _msg_len
	mov ah, 3

_print:
	mov al, [ds:si]
	mov [es:di], ax
	add si, 1
	add di, 2
	loop _print

	pop cx
	pop bx
	pop ax
	pop di
	pop si
	pop es
	pop ds

	retf
_int_func_len equ ($ - _int_func)

;================================


