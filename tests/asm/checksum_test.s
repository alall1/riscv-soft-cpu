main:
    addi x31, x0, 0

    addi x5, x0, 12
    sw x5, 0(x31)

    addi x5, x0, -7
    sw x5, 4(x31)

    addi x5, x0, 25
    sw x5, 8(x31)

    addi x5, x0, 4
    sw x5, 12(x31)

    addi x5, x0, -16
    sw x5, 16(x31)

    addi x5, x0, 33
    sw x5, 20(x31)

    addi x10, x31, 0
    addi x11, x0, 6
    addi x12, x0, 10
    addi x13, x0, 124

    jal x1, checksum_filter

    sw x10, 128(x31)

    lw x14, 124(x31)
    sw x14, 132(x31)

    ebreak

checksum_filter:
    addi x5, x10, 0
    addi x6, x11, 0
    addi x7, x0, 0
    addi x8, x0, 0

loop:
    beq x6, x0, done

    lw x9, 0(x5)

    blt x9, x12, less_than_threshold
    jal x0, after_threshold_check

less_than_threshold:
    addi x8, x8, 1

after_threshold_check:
    andi x14, x9, 1

    beq x14, x0, even_value

    slli x15, x9, 1
    xor x7, x7, x15
    jal x0, after_mix

even_value:
    srai x15, x9, 1
    add x7, x7, x15

after_mix:
    addi x5, x5, 4
    addi x6, x6, -1
    jal x0, loop

done:
    sw x8, 0(x13)
    addi x10, x7, 0
    jalr x0, x1, 0
