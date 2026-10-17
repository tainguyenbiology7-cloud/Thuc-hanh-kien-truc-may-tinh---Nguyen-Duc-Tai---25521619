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
    li $v0, 4                    #thanh ghi $v0 lưu mã dịch vụ của lệnh syscall
    la $a0, prompt_1             #$a0 ghi lại dữ liệu được nhập vào hoặc cần được in ra
    syscall
    li $v0, 5     
    syscall
    move $t0, $v0                #$t0 lưu số kWh được nhập vào 
    sltiu $t1, $t0, 10000        #$t1 lưu kwts quả phép so sánh kiểm tra đầu vào 
    bne $t1, $zero, Calculate
    li $v0, 4  
    la $a0, error
    syscall
    j Insert
   Calculate:
    li $t2, 0    #$t2 Lưu tổng tiền điện cưối cùng 
    li $t3, 0    #$t3 Lưu giới hạn cảu bậc liền trước 
    li $t4, 0    #$t4 Lưu biến đếm i để tangư lên sau mỗi vòng lặp 
    li $t5, 6    #$t5 Lưu số 6 - Tổng số bậc cần tính 
    la $s0, limits     #$s0 Luu địa chỉ cơ sở cảu mảng limits tức phần từ dầu tiên và sẽ được dùng để lấy các gíá trị tiếp theo trong vòng lặp 
    la $s1, prices     #$s1 Luu địa chỉ cơ sở cảu mảng prices tức phần từ dầu tiên và sẽ được dùng để lấy các gíá trị tiếp theo trong vòng lặp 
   Loop_calculate:
    beq $t4, $t5, Result
    sll $s2, $t4, 2    #$s2 lưu offset để lấy phần tử của mảng 
    add $s3, $s0, $s2  #$s3 lấy địa  chỉ của phần tử mong muốn trogn mảng limits 
    lw $t6, 0($s3)     #$t6 lưu giới hạn của bậc thứ i 
    
    add $s3, $s1, $s2 #$s3 lấy địa  chỉ của phần tử mong muốn trogn mảng limits 
    lw $t7, 0($s3)   #$t7 Lưu giá cảu bậc thứ 
    
    slt $t8, $t6, $t0    #$t8 Lưu tạm kết quả phép so sánh để chọn cách tính
    bne $t8, $zero, Greater_limit
    
    sub $t9, $t0, $t3    #$t9 Lưu số kWh đã dùng ở bậc thứ i
    mul $t8, $t9, $t7    #$t8 lưu giá tiền điện đã dùng tại bậc thứ i
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
    
