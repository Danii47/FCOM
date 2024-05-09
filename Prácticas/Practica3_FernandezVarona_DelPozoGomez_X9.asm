.data
	primeNumbersVector: .word 2, 3, 5, 7, 11, 13, 17, 19, 0
	factorizationVector: .space 28
	
	inputNumberText: .asciiz "Introduce un número: "
	errorText: .asciiz "ERROR: "
	
	errorTypeText1: .asciiz "El número a factorizar es menor que 2"
	errorTypeText2: .asciiz "El número introducido tiene un factor primo mayor que los considerados."
	
.text
	main:
		la $a0, inputNumberText
		li $v0, 4
		syscall
		
		li $v0, 5
		syscall
		
		add $a0, $v0, $0
		la $a1, primeNumbersVector
		la $a2, factorizationVector
		
		
		jal factorizer
		
		
		li $v0, 10
		syscall
		
	factorizer: 

		sw $ra 0($sp)
		addi $sp, $sp, -4

		lw $t0, 0($a1)
		div $a1, $t0
		
		mfhi $t1
		
		bne $t1, $0, notDivisor
			
		 
		sw $t0, 0($a2)
		
		addi $a2, $a2, 4
		mflo $a0
		beq $a0, 1, exitFunction
		j recallFunction
			
		notDivisor: 
			addi $a1, $a1, 4
			
		recallFunction:
			jal factorizer
	
		exitFunction:
		
			jr $ra
	
	
		