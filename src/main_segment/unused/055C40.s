#include "hasm.h"

.section .text, "ax"


/**
 * void func_8007F890(u32 *dst, u32 *src);
 *
 * Roughly equivalent to:
 * ```
void func_8007F890(s32 *dst, u32 *src) {
    u32 val = 0x10001;
    s32 temp_t5_2;
    s32 temp_t6;
    s32 temp_t7;
    s32 var_a2;
    s32 var_t2;
    s32 var_t3;
    s32 var_t4;
    s32 var_v0;
    s32 var_v1;
    u32 temp_t5;
    u32 var_a3;

    for (var_v0 = 0xF0; var_v0 != 0; var_v0--) {
        var_a2 = 1;
        var_t2 = 0;
        var_t3 = 0;
        var_t4 = 0;

        for (var_v1 = 0xA0; var_v1 != 0; var_v1--) {
            var_a3 = *src++;
            temp_t5 = var_a3 >> 0x10;
            temp_t5_2 = temp_t5 & 0x3E;
            temp_t6 = (var_a3 >> 0x16) & 0x1F;
            temp_t7 = (var_a3 >> 0x1B) & 0x1F;
            if ((temp_t5 & 1) != var_a2) {
                var_a2 ^= 1;
                var_a3 = (var_a3 & 0xFFFF) |
                         ((((u32)(var_t4 + temp_t7) >> 1) << 0x1B) | (((u32)(var_t3 + temp_t6) >> 1) << 0x16) |
                          (((u32)(var_t2 + temp_t5_2) >> 1) << 0x10));
            }
            var_t2 = var_a3 & 0x3E;
            var_t3 = (var_a3 >> 6) & 0x1F;
            var_t4 = (var_a3 >> 0xB) & 0x1F;
            if ((var_a3 & 1) != var_a2) {
                var_a2 ^= 1;
                var_a3 =
                    (var_a3 & 0xFFFF0000) | ((((u32)(temp_t7 + var_t4) >> 1) << 0xB) |
                                             ((u32)(temp_t5_2 + var_t2) >> 1) | (((u32)(temp_t6 + var_t3) >> 1) << 6));
            }
            *dst++ = var_a3 | val;
        }

        dst += 4;
    }
}
 * ```
 */
LEAF(func_8007F890)
    li          $t0, 0x10001
    li          $t8, 0xFFFF
    li          $t9, 0xFFFF0000
    li          $v0, 0xF0

    .L8007F8A4:
        li          $a2, 0x1
        move        $t2, $zero
        move        $t3, $zero
        move        $t4, $zero
        li          $v1, 0xA0

        .L8007F8B8:
            lw          $a3, ($a1)
            addu        $a1, 0x4
            srl         $t5, $a3, 16
            srl         $t6, $a3, 22
            srl         $t7, $a3, 27
            andi        $t1, $t5, 0x1
            andi        $t5, $t5, 0x3E
            andi        $t6, $t6, 0x1F
            andi        $t7, $t7, 0x1F

            beq         $t1, $a2, .L8007F918

            addu        $t4, $t7
            addu        $t3, $t6
            addu        $t2, $t5
            srl         $t4, $t4, 1
            srl         $t3, $t3, 1
            srl         $t2, $t2, 1
            sll         $t4, $t4, 27
            sll         $t3, $t3, 22
            sll         $t2, $t2, 16
            or          $t4, $t3
            and         $a3, $t8
            or          $t4, $t2
            xor         $a2, 0x1
            or          $a3, $t4

            .L8007F918:
            srl         $t3, $a3, 6
            srl         $t4, $a3, 11
            andi        $t1, $a3, 0x1
            andi        $t2, $a3, 0x3E
            andi        $t3, 0x1F
            andi        $t4, 0x1F

            beq         $t1, $a2, .L8007F968

            addu        $t7, $t4
            addu        $t6, $t3
            addu        $t5, $t2
            srl         $t7, $t7, 1
            srl         $t6, $t6, 1
            srl         $t5, $t5, 1
            sll         $t7, $t7, 11
            sll         $t6, $t6, 6
            or          $t7, $t5
            and         $a3, $t9
            or          $t7, $t6
            xor         $a2, 0x1
            or          $a3, $t7

            .L8007F968:
            or          $a3, $t0
            addu        $v1, -0x1
            sw          $a3, ($a0)
            addu        $a0, 0x4

        bnez        $v1, .L8007F8B8

        addu        $v0, -0x1
        addu        $a0, 0x10

    bnez        $v0, .L8007F8A4
    jr          $ra
END(func_8007F890)


/**
 * void func_8007F990(u32 *dst, u32 *src);
 *
 * Roughly equivalent to:
 * ```
void func_8007F990(u32 *dst, u32 *src) {
    u32 val = 0x10001;
    s32 var_t8;
    s32 var_t9;

    for (var_t8 = 0xF0; var_t8 != 0; var_t8--) {
        for (var_t9 = 0xA0; var_t9 != 0; var_t9--) {
            *dst++ = *src++ | val;
        }

        dst += 4;
    }
}
 * ```
 */
LEAF(func_8007F990)
    li          $t1, 0x10001
    li          $t8, 0xF0

    .L8007F99C:
        li          $t9, 0xA0

        .L8007F9A0:
            lw          $t0, ($a1)
            addu        $a1, 0x4
            or          $t0, $t1
            addu        $t9, -0x1
            sw          $t0, ($a0)
            addu        $a0, 0x4
        bnez        $t9, .L8007F9A0

        addu        $t8, -0x1
        addu        $a0, 0x10
    bnez        $t8, .L8007F99C

    jr          $ra
END(func_8007F990)


/**
 * void func_8007F9D0(u32 *dst, u32 *src);
 *
 * Roughly equivalent to:
 * ```
void func_8007F9D0(u32 *dst, u32 *src) {
    u32 val = 0x10001;
    s32 var_t8;

    for (var_t8 = 0x9600; var_t8 != 0; var_t8--) {
        *dst++ = *src++ | val;
    }
}
 * ```
 */
LEAF(func_8007F9D0)
    li          $t1, 0x10001
    li          $t8, 0x9600

    1:
        lw          $t0, ($a1)
        addu        $a1, 0x4
        or          $t0, $t1
        addu        $t8, -0x1
        sw          $t0, ($a0)
        addu        $a0, 0x4
    bnez        $t8, 1b

    jr          $ra
END(func_8007F9D0)
