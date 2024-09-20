.data
message:
    .ascii      "Hello World!\n"   
message_len = . - message          @ 计算字符串的长度

.text
.globl _start                      @ 程序的入口点
_start:
    mov     r0, #1                @ 将 r0 设置为 1，表示输出到标准输出
    ldr     r1, =message          @ 将 message 的地址加载到 r1 中，
    ldr     r2, =message_len      @ 要输出的字符串长度
    mov     r7, #4                @ 系统调用号 4，即 write 系统调用
    svc     #0                    @ 触发系统调用，将 message 输出到 stdout

    mov     r0, #0                @ 退出状态码为 0，表示正常退出
    mov     r7, #1                @ 系统调用号 1，即 exit 系统调用
    svc     #0                    @ 触发系统调用 (exit)，结束程序

