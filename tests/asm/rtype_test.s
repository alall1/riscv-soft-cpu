main:
	addi x1, x0, 1
	add x2, x1, x1
	sub x3, x1, x2
	xor x4, x3, x2
	or x5, x4, x1
	and x6, x5, x3
	sll x7, x6, x1
	srl x8, x2, x1
	sra x9, x7, x8
	slt x10, x9, x1
	sltu x11, x1, x9

	sw x9, 0(x0)
	sw x10, 4(x0)
	sw x11, 8(x0)

	ebreak
