.data
pitchs: .word 64, 64, 65, 67, 67, 65, 64, 62, 60, 60, 62, 64, 64, 62, 62
durations: .word 2, 2, 2, 2, 2, 2, 2, 2, 2, 2, 2, 2, 3, 1, 4
notes: .word 15
space: .asciiz " "
newline: .asciiz "\n"
total: .asciiz "\nTong du kien: "
measured: .asciiz "\nThoi gian do duoc (ms): "
.text
Main: 
   li $v0, 30
   syscall
   move $s6, $a0  #Thoi gian bat dau
   
   li $t0, 0    #chỉ số vòng lặp i = 0 
   lw $t1,notes   
   la $s0, pitchs 
   la $s1, durations
   li $s2, 1          #chi so b
   li $t2, 10         #luu so 10
   mul $t3, $t2, $s2  #luu ket qua 10*b
   addi $t3, $t3, 150 #150 + 10*b
   li $s3, 0          #Tong thoi luong
 play:
   beq $t0, $t1, end 
   sll $t4, $t0, 2
   add $t5, $s0, $t4 
   lw $a0, 0($t5)    # Cao do
   add $t5, $s1, $t4
   lw $t6, 0($t5)    # Do dai theo nhip
   mul $a1, $t6, $t3 #Thoi luong $a1 = duration * $t3
   add $s3, $s3, $a1 #Tong thoi luong
   li $a2, 19 #Instrument = Church organ
   li $a3, 100 #Am luong = 100
   #in cao do
   li $v0, 1
   syscall 
   #In khoang trang
   li $v0, 4
   la $a0, space
   syscall
   #In thoi luong
   li $v0, 1
   move $a0, $a1
   syscall
   #Xuong hang
   li $v0, 4
   la $a0, newline
   syscall
   #Thay lai cao do ban dau de phat nhac
   sll $t4, $t0, 2
   add $t5, $s0, $t4 
   lw $a0, 0($t5)    # Cao do
   li $v0, 33  
   syscall
   #Tang bien dem
   addi $t0, $t0, 1
   j play
 end:
   li $v0, 30 #Doc thoi gian ket thuc
   syscall
   move $t7, $a0 #Thoi gian ket thuc
   sub $s4, $t7, $s6 #Thoi gina do duoc
   #In tong du kien
   li $v0, 4
   la $a0, total
   syscall
   li $v0, 1
   move $a0, $s3
   syscall
   #In thoi gian do duoc
   li $v0, 4
   la $a0, measured
   syscall
   li $v0, 1
   move $a0, $s4
   syscall
   li $v0, 10
   syscall
   
   
   
   
   
   
   
   
   
   