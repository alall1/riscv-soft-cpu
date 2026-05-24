main:
	addi x1, x0, 1

	jal x5, target
	addi x1, x1, 1

after_jalr:
	jal x0, done_jumps
	addi x2, x2, 1

target:
	addi x1, x1, 1
	jalr x6, x5, 0
	addi x2, x2, 1

done_jumps:
	sw x1, 0(x0)
	sw x2, 4(x0)

	ebreak
