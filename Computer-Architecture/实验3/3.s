# 代码段
.text

main:   # 程序入口 main
ADDIU $r1,$r0,array1  # array1的地址
ADDIU $r2,$r0,array2  # array2的地址
ADDIU $r3,$r0,10  # 变量控制循环出口
ADDIU $r7,$r0,0   # 初始化r7
loop:
LW $r4,0($r1)
LW $r5,0($r2)
MUL $r6,$r4,$r5
ADD $r7,$r7,$r6   # r7存放点积结果
ADDI $r1,$r1,4    # 继续读取数组
ADDI $r2,$r2,4
ADDI $r3,$r3,-1   # r3 控制程序出口
BGTZ $r3,loop     # if r3>0：loop
TEQ $r0,$r0

# 数据段
.data 
array1: .word 0,1,2,3,4,5,6,7,8,9
array2: .word 0,1,2,3,4,5,6,7,8,9
