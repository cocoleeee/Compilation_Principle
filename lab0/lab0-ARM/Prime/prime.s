.section .data
prompt_msg:
    .asciz "请输入一个整数：\n"     
prime_msg:
    .asciz "是素数\n"               
not_prime_msg:
    .asciz "不是素数\n"             

.section .bss
n:
    .space 4          @ 为存储输入的整数预留 4 字节的空间
buffer:
    .space 10         @ 为存储用户输入的 ASCII 字符预留 10 字节的空间

.section .text
.global _start

_start:
    @ 输出提示信息
    ldr r0, =1                       
    ldr r1, =prompt_msg               
    mov r2, #25                       
    mov r7, #4                       
    svc #0                            

    @ 读取输入的 ASCII 字符
    ldr r0, =0                        
    ldr r1, =buffer                   @ 将 buffer 的地址作为存储输入的缓冲区
    mov r2, #10                       @ 最多读取 10 字节
    mov r7, #3                        @ 系统调用号 3，用于读取输入
    svc #0                            

    @ 将 ASCII 字符转换为整数
    ldr r3, =buffer                   @ buffer 的地址
    mov r0, #0                        @ 初始化 r0 为 0，存放最终的整数
convert_loop:
    ldrb r1, [r3], #1                 @ 从 buffer 中逐字节读取字符，r3 每次加 1
    cmp r1, #'0'                      @ 判断当前字符是否小于 '0'
    blt done_convert                  
    cmp r1, #'9'                      @ 判断当前字符是否大于 '9'
    bgt done_convert                 
    sub r1, r1, #'0'                  @ 将 ASCII 字符转为对应的数字

    @ r0 = r0 * 10 + r1
    mov r2, r0                        @ 将当前的 r0 备份到 r2
    mov r4, #10                       @ 将常数 10 赋值给 r4
    mul r0, r2, r4                    @ r0 = r0 * 10
    add r0, r0, r1                    @ r0 = r0 * 10 + r1
    b convert_loop                    @ 继续转换下一个字符

done_convert:
    @ 将转换后的整数结果存储到 n 中
    ldr r3, =n                        @ 载入 n 的地址
    str r0, [r3]                      @ 将 r0 中的整数存入 n

    @ 判断是否是素数
    ldr r0, [r3]                      @ 从 n 中载入输入的整数到 r0
    cmp r0, #2                        @ 判断是否小于 2
    blt not_prime                     @ 如果小于 2，则不是素数
    mov r1, #2                        @ 初始化 r1 为 2，从 2 开始除

check_division:
    cmp r1, r0                        @ 判断 r1 是否等于 r0
    beq prime                         @ 如果 r1 == r0，那么是素数
    mov r4, r0                        @ 将 r0 备份到 r4
    udiv r2, r4, r1                   @ r2 = r0 / r1，进行除法操作
    mul r5, r2, r1                    @ r5 = r2 * r1，检查除法结果是否能整除
    cmp r0, r5                        @ 比较 r0 和 r5，判断是否能被 r1 整除
    beq not_prime                     @ 如果能整除，说明不是素数，跳转到not_prime

    add r1, r1, #1                    @ r1 = r1 + 1，继续检查下一个可能的因子
    b check_division                  @ 回到 check_division 继续检查

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

