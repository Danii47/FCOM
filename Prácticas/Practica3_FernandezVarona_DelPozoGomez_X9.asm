.data
	primeNumbersVector: .word 2, 3, 5, 7, 11, 13, 17, 19, 23, 29, 31, 37, 41, 43, 47, 53, 59, 61, 67, 71, 73, 79, 83, 89, 97, 0
	factorizationVector: .space 200
	
	inputNumberText: .asciiz "Introduce un número: "

	errorTypeText1: .asciiz "ERROR: El número a factorizar es menor que 2."
	errorTypeText2: .asciiz "ERROR: El número introducido tiene un factor primo mayor que los considerados."
	
	printFactorsText1: .asciiz " * "
	printFactorsText2: .asciiz "^"
	printFactorsText3: .asciiz " = "
.text
	main:
		la $a0, inputNumberText
		li $v0, 4
		syscall
		
		li $v0, 5
		syscall
		
		add $s0, $v0, $0
		add $a0, $v0, $0
		
		la $a1, primeNumbersVector
		la $a2, factorizationVector
		
		
		jal factorizer
		
		bgt $v0, $0, finishProgram
		
		add $a0, $0, $s0
		li $v0, 1
		syscall
		
		la $a0, printFactorsText3
		li $v0, 4
		syscall
		
		la $a0, factorizationVector
		jal printResult
		
		finishProgram:
			li $v0, 10
			syscall
		
	factorizer: 

		sw $ra 0($sp)
		addi $sp, $sp, -4

		blt $a0, 2, error1

		lw $t0, 0($a1)
		div $a0, $t0
		
		mfhi $t1
		
		bne $t1, $0, notDivisor
			
		 
		sw $t0, 0($a2)
		
		addi $a2, $a2, 4
		mflo $a0
		
		
		beq $a0, 1, validEnd
		j recallFunction
			
		notDivisor: 
			addi $a1, $a1, 4
			lw $t2, 0($a1)
			beq $t2, $0, error2
			
		recallFunction:
			jal factorizer
	
		exitFactorizer:
		
			addi $sp, $sp, 4
			lw $ra, 0($sp)
		
			jr $ra
	
		validEnd:
			li $v0, 0
			j exitFactorizer
	
		error1:
			la $a0, errorTypeText1
			li $v0, 4
			syscall
			
			li $v0, 1
			j exitFactorizer
		
		error2:
			la $a0, errorTypeText2
			li $v0, 4
			syscall
		
			li $v0, 2
			j exitFactorizer


	printResult:
		addi $t2, $0, 1								# $t2 -> Contador de repeticiones del factor primo
		add $t3, $0, $a0
		
		printResultLoop:
			lw $t0, 0($t3)
			lw $t1, 4($t3)
		
			beq $t0, $0, exitPrintResult
		
			# va a poner el signo de multiplicar al final
		
			addi $t3, $t3, 4
		
			beq $t0, $t1, numberRepeat
			
			add $a0, $0, $t0
			li $v0, 1
			syscall
			
			beq $t2, 1, printSingleFactor
			j printMultipleFactor
		
	numberRepeat:
		addi $t2, $t2, 1
		j printResultLoop
		
	printSingleFactor:
		
		beq $t1, $0, exitPrintResult
	
		la $a0, printFactorsText1
		li $v0, 4
		syscall
		
		j printResultLoop
	
	printMultipleFactor:
		
		la $a0, printFactorsText2
		li $v0, 4
		syscall
		
		add $a0, $0, $t2
		li $v0, 1
		syscall
		
		beq $t1, $0, exitPrintResult
		
		la $a0, printFactorsText1
		li $v0, 4
		syscall
		
		addi $t2, $0, 1
		j printResultLoop
	
	exitPrintResult:
		jr $ra
	
	
	
	
	
	
	
	
	
	
	
	
	
	
	
	
	
	