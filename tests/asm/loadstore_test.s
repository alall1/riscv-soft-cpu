main:
	addi x1, x0, 1
	addi x2, x0, 2
	addi x3, x0, -3

	sb x1, 0(x0)
	sb x2, 1(x0)
	sh x3, 2(x0)

	lb x4, 0(x0)
	lb x5, 0(x1)
	lb x6, 0(x2)
	lh x7, 2(x0)
	lbu x8, 2(x0)
	lhu x9, 2(x0)

	add x10, x4, x5
	add x10, x10, x6
	add x10, x10, x7
	add x10, x10, x8
	add x10, x10, x9

	sw x10, 4(x0)
	lw x11, 4(x0)

	addi x11, x11, -1000

	sw x11, 0(x0)

	ebreak
