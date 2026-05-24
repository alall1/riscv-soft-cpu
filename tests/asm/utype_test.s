main:
	lui x1, 74565
	auipc x2, 74565

	sw x1, 0(x0)
	sw x2, 4(x0)

	ebreak
