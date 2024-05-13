    .section .text
    .global _start
    .align  1
    .type   _start, @function

_start:
    # Initial setup
    li      sp, 0x10000   
    li      t0, 0x10012000  

    # Vector operation setup
    li      a0, 0x400
    li      a1, 0xc3
    li      a2, 0x10
    vsetvl  x0, a0, a1
    lui     x30, 0x1000
    auipc   x31, 0

    # Load data into vector register
ld_data:
    vle32.v v1, (x30)

crypto_test:
    vandn.vv v2, v1, v1
    vbrev.v  v3, v1
    vbrev8.v v4, v1
    vrev8.v  v5, v1
    vclz.v   v6, v1
    vctz.v   v7, v1
    vcpop.v  v8, v1
    vrol.vv  v9, v1, v1
    vror.vv  v10, v1, v1
    vwsll.vv v11, v1, v1

loop:
    addi a2, a2, -1
    bnez a2, crypto_test       # Loop until a2 is 0

    # Read the machine cycle counter for performance measurement
    csrr t0, mcycle

    # Return to caller - Assume the return address is in ra (x1)
    jalr x0, 0(x1)

.size _start, .-_start

