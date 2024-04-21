.data
	n1: .word 8
	n2: .word 6
.text
	main:
		la $s0, n1
		la $s1, n2
		
		beq $s0, $s1, Equal
	
	NotEqual:
		addi $t1, $0, 4
		sub $t0, $t1, $s0
		sw $t0, ($s0)
		
		j EndProgram
		
	Equal:
		addi $t0, $s0, 4
		sw $t0, ($s0)
		
	EndProgram:
		li $v0 10
		syscall
		
		
	
	