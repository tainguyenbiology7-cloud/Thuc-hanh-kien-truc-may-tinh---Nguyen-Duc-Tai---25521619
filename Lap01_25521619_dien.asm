.data
limits: .word 50, 100, 200, 300, 400, 9999
prices: .word 1780, 1840, 2130, 2680, 3030, 3180
prompt_1: .asciiz "Nhap so kWh (0...9999): "
error: .asciiz "Gia tri khong hop le, nhap lai.\n: "
total: .asciiz "Tong tien: "
dong: .asciiz " dong\n"
.text
  Main:
   Insert:
    li $v0, 4
    la $a0, prompt_1
    syscall
    li $v0, 5
    syscall
    move $t0, $v0
    sltiu $t1, $t0, 10000
    bne $t1, $zero, Calculate
    li $v0, 4
    la $a0, error
    syscall
    j Insert
   Calculate:
    li $t2, 0
    li $t3, 0
    li $t4, 0
    li $t5, 6
    la $s0, limits
    la $s1, prices
   Loop_calculate:
    beq $t4, $t5, Result
    sll $s2, $t4, 2
    add $s3, $s0, $s2
    lw $t6, 0($s3)
    
    add $s3, $s1, $s2
    lw $t7, 0($s3)
    
    slt $t8, $t6, $t0
    bne $t8, $zero, Greater_limit
    
    sub $t9, $t0, $t3
    mul $t8, $t9, $t7
    add $t2, $t2, $t8
    j Result
   Greater_limit:
    sub $t9, $t6, $t3
    mul $t8, $t9, $t7
    add $t2, $t2, $t8
    move $t3, $t6
    addi $t4, $t4, 1
    j Loop_calculate
   Result:
    li $v0, 4
    la $a0, total
    syscall
    li $v0, 1
    move $a0, $t2
    syscall
    li $v0, 4
    la $a0, dong
    syscall
    
    li $v0, 10
    syscall
    