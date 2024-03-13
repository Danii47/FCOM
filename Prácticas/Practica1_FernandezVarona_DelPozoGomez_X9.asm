.data
	A: .word 0, 1, 1, 2, 3, 5, 8, 13, 21, 34

.text
	main: 
		la $s0, A
		add $s1, $zero, $0
		add $s2, $zero, $0
		
	Loop: 
		sll $t0, $s1, 2
		add $t1, $t0, $s0
		lw $t2, 0($t1)
		add $s2, $s2, $t2
		slti $t3, $s1, 10
		addi $s1, $s1, 1
		bne  $s1, 10, Loop
		
		li $v0 10
		syscall