main:
    addi x8, x0, 64

    addi x1, x0, 5
    addi x2, x1, 3

    auipc x3, 0
    addi x3, x3, 16
    jalr x0, x3, 0

    addi x2, x2, 100

target:
    sw x2, 0(x8)

    ebreak
