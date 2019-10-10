image: bootsect.bin setup.bin
	dd if=bootsect.bin of=image bs=512 count=1
	dd if=setup.bin of=image bs=512 count=4 seek=1

bootsect.bin: bootsect.s
	nasm bootsect.s -o bootsect.bin

setup.bin: setup.s
	nasm setup.s -o setup.bin

run: image
	qemu-system-i386 -boot a -fda image

.PHONY=clean
clean:
	rm *.o *.bin image
