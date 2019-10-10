int main() {
	asm("nop");
	asm("nop");
	asm("mov $0, %ax");
	asm("nop");
	return 0;
}