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


	cli

	call _func_set_gdt_idt
	call _func_enable_a20


	;// cr0 32位寄存器，0位保护模式开启使能
	;mov eax, cr0
	;or eax, 1
	;mov cr0, eax
	mov eax, 1
	mov cr0, eax

	;// 这里设置进入32 位保护模式运行。首先加载机器状态字(lmsw - Load Machine Status Word)，
	;// 也称控制寄存器CR0，其比特位0 置1 将导致CPU 工作在保护模式。
	;mov	ax,0001h	;// 保护模式比特位(PE)。
	;lmsw ax			;// 就这样加载机器状态字

	;sti

	mov ax, 24
	mov es, ax
	mov ah, 3
	
	mov al, 0x77
	mov [es:0], ax			;//终端显示青色的'w'

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
	push es
	mov ax, 24
	mov es, ax

	mov ah, 3
	mov al, 0x79
	mov [es:0], ax			;//终端显示青色的'w'
	pop es
	ret

;//========================================================================

_msg_hello:
	db "Hello, setup!"
	db 0x0a, 0x0d, 0

;//========================================================================

_func_enable_a20:
	;in al, 0x92
	;or al, 2
	;out 0x92, al

	;// 以上的操作很简单，现在我们开启A20 地址线。

	call empty_8042		;// 等待输入缓冲器空。
						;// 只有当输入缓冲器为空时才可以对其进行写命令。
	mov	al,0D1h			;// D1 命令码-表示要写数据到8042 的P2 端口。P2 端
	out	64h,al			;// 口的位1 用于A20 线的选通。数据要写到60 口。

	call empty_8042		;// 等待输入缓冲器空，看命令是否被接受。
	mov	al,0DFh			;// A20 on 选通A20 地址线的参数。
	out	60h,al
	call empty_8042		;// 输入缓冲器为空，则表示A20 线已经选通。

	ret


;// 下面这个子程序检查键盘命令队列是否为空。这里不使用超时方法- 如果这里死机，
;// 则说明PC 机有问题，我们就没有办法再处理下去了。
;// 只有当输入缓冲器为空时（状态寄存器位2 = 0）才可以对其进行写命令。
empty_8042:
	dw 00ebh,00ebh	;// jmp $+2, jmp $+2 $ 表示当前指令的地址
						;// 这是两个跳转指令的机器码(跳转到下一句)，相当于延时空操作。
	in	al,64h			;// 读AT 键盘控制器状态寄存器。
	test al,2			;// 测试位2，输入缓冲器满？
	jnz	empty_8042		;// yes - loop
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
	dd 0, 0

	dw 0x07ff
	dw 0x0000
	db 0x00
	db 10011010b
	db 11000000b
	db 0x00

	dw 0x07ff
	dw 0x0000
	db 0x00
	db 10010010b
	db 11000000b
	db 0x00

	dw 0xffff
	dw 0x8f00
	db 0x0b
	db 10010010b
	db 11001111b
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

_stack:
	times 128 db 0
_stack_top equ ($)

;//========================================================================

_blank:
	times (0x800 - ($ - $$)) db 0

;//========================================================================
