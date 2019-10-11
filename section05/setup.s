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

	call _func_test1
	
	;call _func_test_show

	cli

	call _func_set_gdt_idt
	call _func_enable_a20
	call _func_protect_model

	;sti

	call _func_test2
	call _func_test3

	;mov ax, 24
	;mov es, ax
	;mov ah, 2
	;mov al, 0x77
	;mov [es:64], ax			;//终端显示青色的'w'

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
_func_test1:
	push es
	mov ax, 0xb800
	mov es, ax
	mov di, 0x0f00
	
	mov ah, 3
	mov al, 0x77
	mov [es:di], ax			;//终端显示青色的'w'
	pop es
	ret

;//========================================================================
_func_test2:
	mov ax, 24
	mov es, ax
	mov ah, 3
	
	mov al, 0x79
	mov [es:2], ax			;//终端显示青色的'y'
	ret

;//========================================================================
_func_test3:
	mov ax, 32
	mov ds, ax
	mov ax, 24
	mov es, ax
	mov si, _msg_hello
	mov di, 32
	mov ah, 3
	
_test3_print:
	mov al, [ds:si]
	add si, 1
	add di, 2
	
	cmp al, 0
	je _test3_exit

	mov [es:di], ax			;//终端显示青色的'w'
	jmp _test3_print


_test3_exit:
	ret

;//========================================================================
;// 开启保护模式。cr0 32位寄存器，0位保护模式使能
_func_protect_model:
	;mov eax, 1
	;mov cr0, eax

	mov eax, cr0
	or eax, 1
	mov cr0, eax

	ret

;//========================================================================
;// 开启A20地址线
_func_enable_a20:
	in al, 0x92
	or al, 2
	out 0x92, al

	ret

;//========================================================================

_func_set_gdt_idt:
	lgdt [ds:_gdt_48]
	lidt [ds:_idt_48]

	ret

;//========================================================================

_gdt_48:
	dw 0x800 			;// GDT的长度 8 * 256，每个向量8字节，共256个
	dw 512 + _gdt, 0x9			;// GDT的位置 0x90200 + _gdt

_gdt:
	;// 低4字节 16~31, 高4字节 0~7, 24~31, 组成一个32位地址
;// 0: null
	dd 0, 0

;// 8: 代码段
	dw 0x07ff
	dw 0x0000
	db 0x00
	db 10011010b
	db 11000000b
	db 0x00

;// 16: 数据段
	dw 0x07ff
	dw 0x0000
	db 0x00
	db 10010010b
	db 11000000b
	db 0x00

;// 24: 显存段
	dw 0xffff
	dw 0x8f00
	db 0x0b
	db 10010010b
	db 11001111b
	db 0x00

;// 32: setup
	dw 0x07ff
	dw 0x0200
	db 0x09
	db 10011010b
	db 11000000b
	db 0x00

	;dw 0x07ff			;// limit 0~2047 2M?
	;dw 0x0000			;// 
	;dw 0x9a00			;// 1001 1010
	;dw 0x00c0			;// 		 1100 0000

	;dw 0x07ff			;// limit 8M 0~2047
	;dw 0x0000			;// 
	;dw 0x9200			;// 1001 0010
	;dw 0x00c0			;// 		 1100 0000

_idt_48:
	dw 0
	dw 0, 0

;//========================================================================
;//========================================================================
;// 测试代码，打印加载到数据
_func_test_show:
	push es

	mov ax, 0x9080

	mov es, ax
	mov si, 0
	mov cx, 512

	mov ah, 0x0e
	mov bx, 15

_test:
	mov al, [es:si]
	inc si
	int 0x10
	loop _test

	pop es
	ret
;//========================================================================
;//========================================================================

_stack:
	times 128 db 0
_stack_top equ ($)

;//========================================================================

_blank:
	times (0x800 - ($ - $$)) db 0

;//========================================================================
