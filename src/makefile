bootsect.bin: bootsect.s
	nasm bootsect.s -o bootsect.bin

run: bootsect.bin
	qemu-system-i386 -boot a -fda bootsect.bin

.PHONY=clean
clean:
	rm *.o *.bin
