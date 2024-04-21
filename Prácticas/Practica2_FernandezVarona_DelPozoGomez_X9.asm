.data
	enterNumber: .asciiz "Introduzca un número: "
	sumEvensText1: .asciiz "La suma de los "
	sumEvensText2: .asciiz " primeros números naturales pares es: "
	
	printRegisterText: .asciiz "El registro correspondiente en MIPS es: "
	
	printRegisterErrorText: .asciiz "ERROR: Número de registro fuera de alcance."
	
	printRegisterDollarText: .asciiz "$"
	printRegisterZeroText: .asciiz "zero"
	printRegisterAtText: .asciiz "at"
	printRegisterVText: .asciiz "v"
	printRegisterAText: .asciiz "a"
	printRegisterTText: .asciiz "t"
	printRegisterSText: .asciiz "s"
	printRegisterKText: .asciiz "k"
	printRegisterGpText: .asciiz "gp"
	printRegisterSpText: .asciiz "sp"
	printRegisterFpText: .asciiz "fp"
	printRegisterRaText: .asciiz "ra"
	
	jumpLine: .asciiz "\n"

.text
	# ENTREGABLE 1
	
	la $a0, enterNumber				#
	li $v0, 4						#
	syscall							#
	
	li $v0, 5						#
	syscall							#
	
	add $t0, $0, $v0				#
	
	bge $t0, $0, isPositiveNumber	# En caso de que el número sea positivo, se salta lo de debajo, en caso contrario el número será multiplicado por -1
	addi $t1, $0, -1				#
	mul $t0, $t0, $t1				# Se multiplica el número por -1 para cambiar el signo

	isPositiveNumber:
		add $a0, $0, $t0			# Se guarda en $a0 el valor de $t0
		addi $t2, $0, 2
		div $t0, $t2			# Se almacena en $t0 el cociente de la división entre $t2 (2) del número introducido
		mflo $t0
		
		jal sumEvens
		add $t1, $0, $v0			# Se almacena en $t1 en valor de $v0 (suma de los $t0 primeros pares)
		
		la $a0, sumEvensText1		#
		li $v0, 4					#
		syscall
		
		add $a0, $0, $t0
		li $v0, 1					#
		syscall
		
		la $a0, sumEvensText2		#
		li $v0, 4					#
		syscall
		
		add $a0, $0, $t1
		li $v0, 1					#
		syscall
		
		la $a0, jumpLine			#
		li $v0, 4					#
		syscall
		
		
		# ENTREGABLE 2
		
		la $a0, enterNumber				#
		li $v0, 4						#
		syscall							#
	
		li $v0, 5						#
		syscall							#
		
		add $a0, $0, $v0
		add $a1, $a1, $0				##### TODO: El $a1 hay que cambiarle el valor???¿¿??¿¿¿¿??
		
		jal printRegister
		
		li $v0, 10
		syscall
		
	sumEvens:
		addi $t1, $0, 2
		addi $v0, $0, 0
		
		sumEvensLoop:
			add $v0, $v0, $t1
			addi $t1, $t1, 2
			ble $t1, $a0, sumEvensLoop
		jr $ra
		
	printRegister:
		add $t0, $0, $a0
		add $t0, $t0, $a1				# Se almacena en $t0 el el valor que hay que comprobar
		
		blt $t0, 0, printRegisterError
		bgt $t0, 31, printRegisterError
		
		la $a0, printRegisterText
		li $v0, 4
		syscall
		
		la $a0, printRegisterDollarText
		li $v0, 4
		syscall
		
		beq $t0, 0, printZero
		beq $t0, 1, printAt
		ble $t0, 3, printV
		ble $t0, 7, printA
		ble $t0, 15, printT0
		ble $t0, 23, printS
		ble $t0, 25, printT8
		ble $t0, 27, printK
		beq $t0, 28, printGp
		beq $t0, 29, printSp
		beq $t0, 30, printFp
		beq $t0, 31, printRa
		
		
		
		printZero:
			la $a0, printRegisterZeroText
			li $v0, 4
			syscall
			j endPrintRegister			
		
		printAt:
			la $a0, printRegisterAtText
			li $v0, 4
			syscall
			j endPrintRegister
		
		printV:
			la $a0, printRegisterVText
			li $v0, 4
			syscall
			
			addi $t0, $t0, -2
			
			add $a0, $0, $t0
			li $v0, 1
			syscall
			j endPrintRegister
			
		printA:
			la $a0, printRegisterAText
			li $v0, 4
			syscall
			
			addi $t0, $t0, -4
			
			add $a0, $0, $t0
			li $v0, 1
			syscall
			j endPrintRegister
		
		printT0:
			la $a0, printRegisterTText
			li $v0, 4
			syscall
			
			addi $t0, $t0, -8
			
			add $a0, $0, $t0
			li $v0, 1
			syscall
			j endPrintRegister
		
		printS:
			la $a0, printRegisterSText
			li $v0, 4
			syscall
			
			addi $t0, $t0, -16
			
			add $a0, $0, $t0
			li $v0, 1
			syscall
			j endPrintRegister
		
		printT8:
			la $a0, printRegisterTText
			li $v0, 4
			syscall
			
			addi $t0, $t0, -16
			
			add $a0, $0, $t0
			li $v0, 1
			syscall
			j endPrintRegister
		
		printK:
			la $a0, printRegisterKText
			li $v0, 4
			syscall
			
			addi $t0, $t0, -26
			
			add $a0, $0, $t0
			li $v0, 1
			syscall
			j endPrintRegister
		
		printGp:
			la $a0, printRegisterGpText
			li $v0, 4
			syscall
			j endPrintRegister
		
		printSp:
			la $a0, printRegisterSpText
			li $v0, 4
			syscall
			j endPrintRegister
			
		printFp:
			la $a0, printRegisterFpText
			li $v0, 4
			syscall
			j endPrintRegister
		
		printRa:
			la $a0, printRegisterRaText
			li $v0, 4
			syscall
			j endPrintRegister
			
		printRegisterError:
			la $a0, printRegisterErrorText
			li $v0, 4
			syscall
			
			
		endPrintRegister:
			jr $ra
		
	
	
	
	