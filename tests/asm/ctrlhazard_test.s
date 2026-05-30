main:
    addi x8, x0, 64
    addi x1, x0, 5
    addi x2, x0, 5
    addi x3, x0, 7
    addi x9, x0, 10
    addi x10, x0, 20
    addi x11, x0, 30
    addi x12, x0, 0

    beq x1, x2, beq_taken
    addi x9, x9, 100
    addi x10, x10, 100

beq_taken:
    addi x13, x0, 1
    addi x14, x0, 2
    addi x15, x0, 3
    addi x16, x0, 4
    addi x9, x9, 1

    addi x17, x0, 5
    addi x18, x0, 6
    addi x19, x0, 7
    addi x20, x0, 8

    bne x1, x2, bne_bad
    addi x9, x9, 2
    jal x0, after_bne_bad

bne_bad:
    addi x9, x9, 100

after_bne_bad:
    addi x13, x0, 9
    addi x14, x0, 10
    addi x15, x0, 11
    addi x16, x0, 12

    jal x0, jump_target
    addi x10, x10, 100
    addi x9, x9, 100

jump_target:
    addi x17, x0, 13
    addi x18, x0, 14
    addi x19, x0, 15
    addi x20, x0, 16
    addi x10, x10, 3

    addi x13, x0, 17
    addi x14, x0, 18
    addi x15, x0, 19
    addi x16, x0, 20

    jal x5, func
    addi x11, x11, 8
    addi x21, x0, 21
    addi x22, x0, 22
    addi x23, x0, 23

    sw x9, 0(x8)
    sw x10, 4(x8)
    sw x11, 8(x8)

    ebreak

func:
    addi x21, x0, 11
    addi x22, x0, 12
    addi x23, x0, 13
    addi x24, x0, 14
    addi x11, x11, 4

    addi x21, x0, 15
    addi x22, x0, 16
    addi x23, x0, 17
    addi x24, x0, 18

    jalr x0, x5, 0
    addi x11, x11, 100
