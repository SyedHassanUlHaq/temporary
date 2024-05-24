.global _start
_start:
    li a0, 0x2200 # MSTATUS_VS & (MSTATUS_VS >> 1)
    csrs mstatus, a0
    csrwi vcsr, 0

    la sp, __stacktop

    // no ra to save
    call test

    // exit
    li a0, 0x80000000
    li a1, -1
    sw a1, 4(a0)
    csrwi vcsr, 0

    .p2align 2

.global test
test:
    addi x1, x1, 1
    li a0, 0x400
    li a1, 0xc1
    li a2, 2
    vsetvl x0, a0, a1
    lui x30, 1
    auipc x31, 0

zvbb_test:
    vadd.vi v0, v0, 10
    vadd.vi v2, v0, 11, v0.t
    vandn.vv v4, v0, v2
    vbrev.v v6, v2
    vrev8.v v8, v2
    vclz.v v10, v2
    vctz.v v12, v2
    vcpop.v v14, v2
    vrol.vv v6, v4, v2
    vror.vv v16, v4, v2

loop:
    addi a2, a2, -1
    bnez a2, zvbb_test      # Loop until a2 is 0 (runs 2 times)

    # Read the machine cycle counter for performance measurement
    csrr t0, mcycle

    # Return to caller - Assume the return address is in ra (x1)
    ret

will_not_be_executed:
    vadd.vv v2, v1, v1
