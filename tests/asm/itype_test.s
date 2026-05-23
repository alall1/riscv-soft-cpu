main:
	addi x1, x0, 15
	xori x2, x1, 27
	ori x3, x2, 50
	andi x4, x3, 47
	slli x5, x4, 1
	srli x6, x5, 2
	addi x7, x6, -50
	srai x8, x7, 2
	slti x9, x8, 1
	sltiu x10, x9, -10

	sw x8, 0(x0)
	sw x9, 4(x0)
	sw x10, 8(x0)

	ebreak
