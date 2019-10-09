org 0x0100

[section .data]

	_data1 db "Hello, world!", 0x0a		;0x0a对应换行符
	_len equ ($ - _data1)
	_data2 times (_len) db 0

[section .text]
  
	mov si, _data1
	mov di, _data2
    
	mov bx, 0
	mov cx, _len

_copy:
	mov al, [ds:si]
	mov [es:di], al
	inc si		;si自加1
	inc di		;di自加1
	loop _copy
	