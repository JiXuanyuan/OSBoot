org 0x0100

	jmp start

data1:
	db 1, 2, 3, 4, 5, 6, 7, 8

data2:
	db 0, 0, 0, 0, 0, 0, 0, 0

start:
	mov si, data1
	mov di, data2

	mov ax, 0
	mov cx, 8

copy:
	mov al, [ds:si]
	mov [es:di], al
	inc si		;si自加1
	inc di		;di自加1
	loop copy
	