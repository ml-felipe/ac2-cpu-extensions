.section .data
.align 3
.global vec1
.align 3
.global vec2

vec1:
    .space 8192        # 1024 * 8 bytes
vec2:
    .space 8192


.section .text
.global popcnt_custom
popcnt_custom:
    li x5, 0               # i = 0
    li x6, 1024            # SIZE
    li x7, 0               # hamming_custom

loop_popcnt:
    slli x28, x5, 3         # offset = i * 8 bytes

    la x29, vec1
    add x10, x29, x28
    ld x11, 0(x10)         # x11 = vec1[i]

    la x29, vec2
    add x10, x29, x28
    ld x12, 0(x10)         # x12 = vec2[i]

    xor x13, x11, x12      # x13 = vec1[i] ^ vec2[i]
    mv x10, x13
    .word 0x0005050B       # popcnt x10, x10
    add x7, x7, x10

    addi x5, x5, 1
    blt x5, x6, loop_popcnt

    mv a0, x7              # return hamming_custom in a0
    ret
