image: bootsect.bin setup.bin
	dd if=bootsect.bin of=image bs=512 count=1
	dd if=setup.bin of=image bs=512 count=4 seek=1

bootsect.bin: bootsect.s
	nasm bootsect.s -o bootsect.bin

setup.bin: setup.s
	nasm setup.s -o setup.bin

run: image
	qemu-system-i386 -boot a -fda image


# 汇编调用c语言测试
main.bin: main.c
	gcc -c main.c
	dd if=main.o of=main.tmp.bin bs=0x1d8 count=1 skip=1
	dd if=main.tmp.bin of=main.bin bs=0x26 count=1
	rm main.tmp.bin

head.bin: head.s
	nasm head.s -o head.bin

image2: bootsect.bin setup.bin head.bin
	dd if=bootsect.bin of=image2 bs=512 count=1
	# dd if=setup.bin of=image bs=512 count=4 seek=1
	dd if=setup.bin of=image2 bs=512 count=3 seek=1
	dd if=head.bin of=image2 bs=512 count=1 seek=4

run2: image2
	qemu-system-i386 -boot a -fda image2


.PHONY=clean
clean:
	rm *.o *.bin image image2
