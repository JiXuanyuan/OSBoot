t4.exe: t4_head t4.s
	cp t4_head t4.exe
	nasm t4.s
	dd if=t4 of=t4.exe bs=512 count=1 seek=1

t3: t3.s
	nasm t3.s

t2: t2.s
	nasm t2.s

t1: t1.s
	nasm t1.s

.PHONY=clean
clean:
	- rm t4 t4.exe
	- rm t3
	- rm t2
	- rm t1
