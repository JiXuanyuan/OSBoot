;global _start

BOOTSEG equ (0x07c0)		;// bootsect的原始地址（段地址，下同）
BOOT_SIZE equ (512)		;// bootsect模块的长度
INITSEG equ (0x9000)		;// bootsect移动后的地址
SETUPSEG equ (0x9020)		;// setup的加载地址
SYSSEG equ (0x1000)		;// system的加载地址

[section .data]


[section .text]

	jmp BOOTSEG:_start

;//========================================================================

_start:
	mov ax, cs
	mov ss, ax
	mov sp, _stack_top
	mov ds, ax
	mov es, ax

	;mov ax, _msg_hello
	;mov bx, _msg_hello_len
	;call _func_print
	mov ax, _msg_hello
	call _func_print0

	mov ax, _msg_copy_boot
	call _func_print0

	call _func_copy_root

	jmp INITSEG:_start2

;// bootsect移动后的入口
_start2:
	mov ax, cs
	mov ss, ax
	mov sp, _stack_top
	mov ds, ax
	mov es, ax

	mov ax, _msg_load_setup
	call _func_print0

	call _func_load_setup
	
	;// 测试代码
	;call _func_test_show
	
	jmp SETUPSEG:0

_fin:
	hlt
	jmp _fin

;//========================================================================
;// 显示字符串
;// ax = 字符串地址
;// bx = 字符串长度
_func_print:
	mov si, ax
	mov cx, bx
	mov ah, 0x0e
	mov bx, 15

_print:
	mov al, [ds:si]
	inc si
	int 0x10
	loop _print

	ret

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
;// 将这个bootsect复制到INITSEG:0处
_func_copy_root:
	push es

	mov ax, INITSEG
	mov es, ax
	mov di, 0
	mov si, 0

	mov cx, BOOT_SIZE
	cld
	rep movsb

	pop es
	ret

;//========================================================================
;// 利用BIOS的0x13中断，将setup从磁盘第2个扇区，加载到SETUPSEG:0处
_func_load_setup:
	;//	读扇区
	;// dh = 磁头号; dl = 驱动器号;
	;// ch = 柱面号; cl = 开始扇区号;
	;// es:bx = 缓冲区地址;
	;// al = 扇区数;
	;// ah = 0x02, 功能码;
	;// 成功: CF ＝ 0;
	mov dx, 0x0000
	mov cx, 0x0002
	mov bx, BOOT_SIZE
	mov al, 4
	mov ah, 0x02
	int 0x13

	jnc _load_ok

	;// 磁盘系统复位
	;// dh = 磁头号; dl = 驱动器号;
	;// ah = 0x00, 功能码;
	;// 成功: CF ＝ 0;
	mov	dx, 0x0000
	mov	ax, 0x0000
	int	0x13
	jmp	_func_load_setup

_load_ok:
	mov ax, _msg_ok
	call _func_print0
	ret

;//========================================================================
;//========================================================================
;// 测试代码，打印加载到数据
_func_test_show:
	push es

	mov ax, SETUPSEG
	;mov ax, INITSEG

	mov es, ax
	mov si, 0
	mov cx, BOOT_SIZE

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

_msg_hello:
	db "Hello, bootsect!"
	db 0x0a, 0x0d, 0			;// '\n\t'
_msg_hello_len equ ($ - _msg_hello)

_msg_copy_boot:
	db "Copy bootsect..."
	db 0x0a, 0x0d, 0

_msg_load_setup:
	db "Load setup..."
	db 0x0a, 0x0d, 0

_msg_ok:
	db "OK!"
	db 0x0a, 0x0d, 0

;//========================================================================

_stack:
	times 128 db 0
_stack_top equ ($)

;//========================================================================

_blank:
	times (510 - ($ - $$)) db 0
	db 0x55, 0xaa

;//========================================================================
