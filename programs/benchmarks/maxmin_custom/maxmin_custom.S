.section .text
.global maxmin_custom
maxmin_custom:
    # x10: a[]   (a0)
    # x11: b[]   (a1)
    # x12: size  (a2)
    # x13: *out_max (a3)
    # x14: *out_min (a4)

    li x15, 0          # i = 0
    li x16, 0          # sum_max
    li x17, 0          # sum_min

loop:
    bge x15, x12, end          # if i >= size, break

    slli t0, x15, 3            # offset = i * 8

    add t1, x10, t0            # t1 = &a[i]
    ld t2, 0(t1)               # t2 = a[i]

    add t3, x11, t0            # t3 = &b[i]
    ld t4, 0(t3)               # t4 = b[i]

    # max
    .word 0x01D3BF0B          # max t5, t2, t4
    add x16, x16, t5           # sum_max += t5

    # min
    .word 0x01D3CF0B           # min t5, t2, t4
    add x17, x17, t5           # sum_min += t5

    addi x15, x15, 1
    j loop

end:
    sd x16, 0(x13)             # *out_max = sum_max
    sd x17, 0(x14)             # *out_min = sum_min
    ret
