.global _start
_start:
    li a0, 0x2200 # MSTATUS_VS & (MSTATUS_VS >> 1)
    csrs mstatus, a0
    csrwi vcsr, 0

    la sp, __stacktop

    // no ra to save
    call test

    // exit
    li a0, 0x10000000
    li a1, -1
    sw a1, 4(a0)
    csrwi 0x7cc, 0

    .p2align 2

.global test
test:
    addi x1, x1, 1
    li a0, 0x400
    li a1, 0xc1
    li a2, 0x10
    vsetvl x0, a0, a1
    lui x30, 1
    auipc x31, 0

add_test:
    vadd.vi v0, v0, 10
    vadd.vi v2, v0, 11, v0.t
    vandn.vv v4, v0, v2
    vrol.vv v6, v4, v2
    vadd.vv v8, v4, v6, v0.t
    vadd.vx v8, v16, x1

chaining_test:
    vadd.vx v24, v16, x1
    vxor.vi v8, v24, 7
    vsll.vi v16, v8, 1

loop:
    addi a2, a2, -1
    bnez a2, test       # Loop until a2 is 0

    # Read the machine cycle counter for performance measurement
    csrr t0, mcycle

    # Return to caller - Assume the return address is in ra (x1)
    jalr x0, 0(x1)

ld_test:
    vle8.v v16, (x30)

will_not_be_executed:
    vadd.vv v2, v1, v1
