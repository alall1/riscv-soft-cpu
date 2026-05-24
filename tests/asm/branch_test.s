main:
	addi x1, x0, 1
	addi x2, x0, -1

	beq x0, x0, test_beq
	addi x1, x1, 1
test_beq:
	bne x1, x0, test_bne
	addi x1, x1, 1
test_bne:
	blt x0, x1, test_blt
	addi x1, x1, 1
test_blt:
	bge x1, x0, test_bge
	addi x1, x1, 1
test_bge:
	bltu x1, x2, test_bltu
	addi x1, x1, 1
test_bltu:
	bgeu x2, x1, test_bgeu
	addi x1, x1, 1
test_bgeu:
	sw x1, 0(x0)

	ebreak
