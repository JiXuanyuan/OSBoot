int main() {
/*	
	;mov ax, 24
	;mov es, ax
	;mov ah, 2
	;mov al, 0x77
	;mov [es:64], ax			;//终端显示青色的'w'
*/
	asm("hlt");
	asm("nop");
	asm("mov $24, %ax");
	asm("mov %ax, %es");
	asm("mov $2, %ah");
	asm("mov $0x77, %al");
	asm("movw $ax, %es:(64)");
	asm("nop");
	return 0;
}