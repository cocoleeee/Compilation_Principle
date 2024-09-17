.section .data
prompt_msg:
    .asciz "请输入一个整数：\n"
prime_msg:
    .asciz "是素数\n"
not_prime_msg:
    .asciz "不是素数\n"

.section .bss
n:
    .space 4          @ 用于存储输入的整数
buffer:
    .space 10         @ 用于存储输入的ASCII字符

.section .text
.global _start

_start:
    @ 输出提示信息
    ldr r0, =1
    ldr r1, =prompt_msg
    mov r2, #25
    mov r7, #4
    svc #0

    @ 读取输入的ASCII字符
    ldr r0, =0        @ 从标准输入读取
    ldr r1, =buffer   @ 将输入存储到 buffer 中
    mov r2, #10       @ 最多读取10个字符
    mov r7, #3        @ sys_read 系统调用
    svc #0

    @ 将 ASCII 字符转换为整数
    ldr r3, =buffer   @ 载入 buffer 的地址
    mov r0, #0        @ 初始化 r0，存放最终的整数
convert_loop:
    ldrb r1, [r3], #1 @ 逐字节读取 buffer 中的字符
    cmp r1, #'0'      @ 判断是否是数字字符
    blt done_convert  @ 小于 '0' 的话，说明结束
    cmp r1, #'9'      @ 大于 '9' 的话，说明结束
    bgt done_convert
    sub r1, r1, #'0'  @ 将 ASCII 转为数字

    @ 执行 r0 = r0 * 10 + r1
    mov r2, r0        @ 备份 r0
    add r2, r2, r2    @ r2 = r0 * 2
    add r2, r2, r2    @ r2 = r0 * 4
    add r2, r2, r0    @ r2 = r0 * 5
    add r2, r2, r1    @ r2 = r0 * 10 + r1
    mov r0, r2        @ 更新 r0

    b convert_loop

done_convert:
    @ 将结果存储到 n 中
    ldr r3, =n
    str r0, [r3]

    @ 判断是否是素数
    ldr r0, [r3]      @ 载入输入的数字
    cmp r0, #2
    blt not_prime      @ 小于2的数不是素数

    mov r1, #2        @ 从2开始除

check_division:
    cmp r1, r0        @ 如果 r1 == r0，跳转到 prime
    beq prime
    mov r4, r0
    udiv r2, r4, r1   @ r2 = r0 / r1
    mul r5, r2, r1    @ r5 = r2 * r1
    cmp r0, r5        @ 如果 r0 == r5，说明 r0 可被 r1 整除
    beq not_prime     @ 如果能整除，跳转到 not_prime

    add r1, r1, #1    @ r1++
    b check_division  @ 继续检查

prime:
    @ 输出是素数的信息
    ldr r0, =1
    ldr r1, =prime_msg
    mov r2, #10
    mov r7, #4
    svc #0
    b end

not_prime:
    @ 输出不是素数的信息
    ldr r0, =1
    ldr r1, =not_prime_msg
    mov r2, #13
    mov r7, #4
    svc #0

end:
    @ 退出程序
    mov r7, #1
    svc #0

