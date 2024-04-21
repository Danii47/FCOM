.data
	enterNumber: .asciiz "Introduzca un número: "
	sumEvensText1: .asciiz "La suma de los "
	sumEvensText2: .asciiz " primeros números naturales pares es: "
	
	printRegisterText: .asciiz "El registro correspondiente en MIPS es: "
	
	printRegisterErrorText: .asciiz "ERROR: Número de registro fuera de alcance."
	
	.align 4
	printRegisterDollarText: .asciiz "$"
	.align 4
	printRegisterZeroText: .asciiz "zero"
	.align 4
	printRegisterAtText: .asciiz "at"
	.align 4
	printRegisterVText: .asciiz "v"
	.align 4
	printRegisterAText: .asciiz "a"
	.align 4
	printRegisterTText: .asciiz "t"
	.align 4
	printRegisterSText: .asciiz "s"
	.align 4
	printRegisterKText: .asciiz "k"
	.align 4
	printRegisterGpText: .asciiz "gp"
	.align 4
	printRegisterSpText: .asciiz "sp"
	.align 4
	printRegisterFpText: .asciiz "fp"
	.align 4
	printRegisterRaText: .asciiz "ra"
	
	translateInstructionText1: .asciiz "Código de operación: "
	translateInstructionText2: .asciiz " (es de tipo R)"
	translateInstructionText3: .asciiz "Registros utilizados: rs = "
	translateInstructionText4: .asciiz "; rt = "
	translateInstructionText5: .asciiz "; rd = "
	translateInstructionText6: .asciiz "La instrucción no es de tipo R"
	
	.align 4
	buffer1: .space 12
	.align 4
	buffer2: .space 12
	.align 4
	buffer3: .space 12
	
	defaultString: .space 20
	encodedString: .space 20
	
	cesarEncodeText1: .asciiz "Mensaje: "
	cesarEncodeText2: .asciiz "Clave: "
	cesarEncodeText3: .asciiz "Cifrado: "
	cesarEncodeErrorText: .asciiz "Clave incorrecta"
	
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
		
		la $a1, buffer1
		la $a2, buffer2
		la $a3, buffer3
		
		la $a0, enterNumber				#
		li $v0, 4						#
		syscall							#
	
		li $v0, 5						#
		syscall							#
		
		add $a0, $0, $v0				
		
		jal translateInstruction
		
		la $a0, jumpLine				#
		li $v0, 4						#
		syscall
		
		# ENTREGABLE 3
		
		la $a0, cesarEncodeText1
		li $v0, 4
		syscall
		
		la $a0, defaultString
		li $a1, 20
		
		li $v0, 8
		syscall
		
		jal changeEndLine
		
		la $a0, cesarEncodeText2
		li $v0, 4
		syscall
		
		li $v0, 5
		syscall
		
		add $a1, $v0, $0
		la $a0, defaultString
		la $a2, encodedString
		
		jal cesarEncode
		
		la $a0, encodedString
		li $v0, 4
		syscall
		
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
		
		blt $t0, 0, printRegisterError
		bgt $t0, 31, printRegisterError
		
		
		
		la $a0, printRegisterDollarText
		li $v0, 4
		syscall
		
		
		lb $a0, 0($a0)
		sb $a0, -9($sp)
		
		
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
			
			lw $a0, 0($a0)
			sw $a0, -8($sp)
			
			j endPrintRegister			
		printAt:
			la $a0, printRegisterAtText
			li $v0, 4
			syscall
			
			lh $a0, 0($a0)
			sw $a0, -8($sp)
			
			j endPrintRegister
		
		printV:
			la $a0, printRegisterVText
			li $v0, 4
			syscall
			
			lb $a0, 0($a0)
			sw $a0, -8($sp)
			
			addi $t0, $t0, -2
			
			add $a0, $0, $t0
			li $v0, 1
			syscall
			
			sw $a0, -4($sp)
			
			j endPrintRegister
			
		printA:
			la $a0, printRegisterAText
			li $v0, 4
			syscall
			
			lb $a0, 0($a0)
			sw $a0, -8($sp)
			
			addi $t0, $t0, -4
			
			add $a0, $0, $t0
			li $v0, 1
			syscall
			
			sw $a0, -4($sp)
			
			j endPrintRegister
		
		printT0:
			la $a0, printRegisterTText
			li $v0, 4
			syscall
			
			lb $a0, 0($a0)
			sw $a0, -8($sp)
			
			addi $t0, $t0, -8
			
			add $a0, $0, $t0
			li $v0, 1
			syscall
			
			sw $a0, -4($sp)
			
			j endPrintRegister
		
		printS:
			la $a0, printRegisterSText
			li $v0, 4
			syscall
			
			lb $a0, 0($a0)
			sw $a0, -8($sp)
			
			addi $t0, $t0, -16
			
			add $a0, $0, $t0
			li $v0, 1
			syscall
			
			sw $a0, -4($sp)
			
			j endPrintRegister
		
		printT8:
			la $a0, printRegisterTText
			li $v0, 4
			syscall
			
			lb $a0, 0($a0)
			sw $a0, -8($sp)
			
			addi $t0, $t0, -16
			
			add $a0, $0, $t0
			li $v0, 1
			syscall
			
			sw $a0, -4($sp)
			
			j endPrintRegister
		
		printK:
			la $a0, printRegisterKText
			li $v0, 4
			syscall
			
			lb $a0, 0($a0)
			sw $a0, -8($sp)
			
			addi $t0, $t0, -26
			
			add $a0, $0, $t0
			li $v0, 1
			syscall
			
			sw $a0, -4($sp)
			
			j endPrintRegister
		
		printGp:
			la $a0, printRegisterGpText
			li $v0, 4
			syscall
			
			lh $a0, 0($a0)
			sw $a0, -8($sp)
			
			j endPrintRegister
			
		printSp:
			la $a0, printRegisterSpText
			li $v0, 4
			syscall
			
			lh $a0, 0($a0)
			sw $a0, -8($sp)
			
			j endPrintRegister
			
		printFp:
			la $a0, printRegisterFpText
			li $v0, 4
			syscall
			
			lh $a0, 0($a0)
			sw $a0, -8($sp)
			
			j endPrintRegister
		
		printRa:
			la $a0, printRegisterRaText
			li $v0, 4
			syscall
			
			lh $a0, 0($a0)
			sw $a0, -8($sp)
			
			j endPrintRegister
			
		printRegisterError:
			la $a0, printRegisterErrorText
			li $v0, 4
			syscall
			
			li $v0, 1
			j exitPrintRegister
			
		endPrintRegister:
			li $v0, 0
			
			exitPrintRegister:
			
				jr $ra
		
	translateInstruction:
		add $t1, $0, $a0
		
		sw $ra, 0($sp)
		
		la $a0, translateInstructionText1
		li $v0, 4
		syscall
		
		srl $a0, $t1, 26
		li $v0, 1
		syscall
		
		bne $a0, $0, translateInstructionError
		
		la $a0, translateInstructionText2
		li $v0, 4
		syscall
		
		la $a0, jumpLine
		li $v0, 4
		syscall
		
		la $a0, translateInstructionText3
		li $v0, 4
		syscall
		
		sll $a0, $t1, 6
		srl $a0, $a0, 27
		
		jal printRegister
		
		lb $t2, -9($sp)
		sb $t2, 0($a1)
		lw $t2, -8($sp)
		sw $t2, 4($a1)
		lw $t2, -4($sp)
		sw $t2, 8($a1)
		
		la $a0, translateInstructionText4
		li $v0, 4
		syscall
		
		sll $a0, $t1, 11
		srl $a0, $a0, 27
		
		jal printRegister
		
		lb $t2, -9($sp)
		sb $t2, 0($a2)
		lw $t2, -8($sp)
		sw $t2, 4($a2)
		lw $t2, -4($sp)
		sw $t2, 8($a2)
		
		la $a0, translateInstructionText5
		li $v0, 4
		syscall
		
		sll $a0, $t1, 16
		srl $a0, $a0, 27
		
		jal printRegister
		
		lb $t2, -9($sp)
		sb $t2, 0($a3)
		lw $t2, -8($sp)
		sw $t2, 4($a3)
		lw $t2, -4($sp)
		sw $t2, 8($a3)
		
		li $v0, 0
		
		exitTranslateInstruction:
			lw $ra, 0($sp)
			jr $ra
			
		translateInstructionError:
			la $a0, translateInstructionText5
			li $v0, 4
			syscall
			
			li $v0, 1
			
			j exitTranslateInstruction
	
	changeEndLine:
		add $t0, $0, $0
		
		changeEndLineLoop:
			lb $t1, 0($a0)
			beq $t1, 10, changeEndLineValue
			
			addi $t0, $t0, 1
			addi $a0, $a0, 1
			blt $t0, $a1, changeEndLineLoop
		
		changeEndLineExit:
			jr $ra
			
		changeEndLineValue:
			add $t1, $0, $0
			sb $t1, 0($a0)
			j changeEndLineExit

	cesarEncode:
		add $t1, $a0, $0
		
		la $a0, cesarEncodeText3
		li $v0, 4
		syscall
		
		bgt $a1, 100, cesarEncodeError1
		ble $a1, 0, cesarEncodeError1
		
		cesarEncodeLoop:
			lb $t0, ($t1)
			
			beq $t0, 0, cesarEncodeEnd
			
			add $t0, $t0, $a1
			
			bge $t0, 128, cesarEncodeError2
			ble $t0, 31, cesarEncodeError2
			
			sb $t0, ($a2)
			
			addi $t1, $t1, 1
			addi $a2, $a2, 1
			
			j cesarEncodeLoop
		
		cesarEncodeEnd:
			
			sb $t0, ($a2)
			li $v0, 0
			
			cesarEncodeExit:
				jr $ra

			
			
		cesarEncodeError1:
			la $a0, cesarEncodeErrorText
			li $v0, 4
			syscall
		
			li $v0, 1
			j cesarEncodeExit
		
		cesarEncodeError2:
			la $a0, cesarEncodeErrorText
			li $v0, 4
			syscall
			
			li $v0, 2
			j cesarEncodeExit
			