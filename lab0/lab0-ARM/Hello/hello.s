.text

.globl _start

_start:
    mov     r0, #1                @ fd 1 (stdout)
    ldr     r1, =message        
    ldr     r2, =message_len    
    mov     r7, #4                @ syscall 4 (write)
    svc     #0                    @ 触发系统调用

    mov     r0, #0                @ exit status 0 (ok)
    mov     r7, #1                @ syscall 1 (exit)
    svc     #0                  
	
.data

message:
    .ascii      "Hello World!\n"
message_len =.-message          

