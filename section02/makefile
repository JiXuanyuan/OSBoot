t4.exe: t4_head t4.s
	cp t4_head t4.exe
	nasm t4.s
	dd if=t4 of=t4.exe bs=512 count=1 seek=1

.PHONY=clean
clean:
	rm t4 t4.exe