.data

	# Defino los textos necesarios para realizar la práctica
	
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
	translateInstructionText6: .asciiz " (la instrucción no es de tipo R)"
	
	
	# Align sirve para que se empiecen a guardar los bits en un byte vacío
	
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
	la $a0, enterNumber					# Se guarda en $a0 el texto que quiero que se muestre por pantalla
	li $v0, 4						
	syscall							
	
	li $v0, 5							# Se pide al usuario un entero
	syscall							
	
	add $t0, $0, $v0					# Se guarda el entero pedido en $t0 para no perderlo
	
	bge $t0, $0, isPositiveNumber		# En caso de que el número sea positivo, se salta a isPositiveNumber, 
	addi $t1, $0, -1					# en caso contrario el número será multiplicado por -1
	mul $t0, $t0, $t1					# Se multiplica el número por -1 para cambiar el signo

	isPositiveNumber:
		add $a0, $0, $t0				# Se guarda en $a0 el valor de $t0
		addi $t2, $0, 2					# Se guarda el entero 2 en $t2
		div $t0, $t2					# Se almacena en $t0 el cociente de la división del entero introducido y $t2 (2)
		mflo $t0						# Se guarda en $t0 dicho resultado
		
		jal sumEvens
		add $t1, $0, $v0				# Se almacena en $t1 en valor de $v0 (suma de los $t0 primeros pares)
										# En $v0, está guardada la suma de los nºs pares hasta el entero introducido
		la $a0, sumEvensText1			# Se guarda la dirección del texto a mostrar por pantalla en $a0
		li $v0, 4						# Se muestra por pantalla dicho texto (La suma de los )
		syscall
		
		add $a0, $0, $t0
		li $v0, 1						# Se muestra por pantalla el entero introducido)
		syscall
		
		la $a0, sumEvensText2			# Se guarda la dirección del texto a mostrar por pantalla en $a0
		li $v0, 4						# Se muestra por pantalla dicho texto ( primeros números naturales es: )
		syscall
		
		add $a0, $0, $t1				# Se pasa el valor de $t1 (la suma) a $a0 
		li $v0, 1						# Se muestra el valor de $a0 por pantalla
		syscall
		
		la $a0, jumpLine
		li $v0, 4
		syscall
		
		
		# ENTREGABLE 2
		
		la $a1, buffer1					# Se cargan a $a1, 2 y 3, los distintos buffers que serán las direcciones
		la $a2, buffer2					# donde estarán guardados los registros 
		la $a3, buffer3
		
		la $a0, enterNumber				# Se muestra por pantalla el texto de enter Number
		li $v0, 4						# Introduzca un número: 
		syscall							
	
		li $v0, 5						# Se pide un entero
		syscall							
		
		add $a0, $0, $v0				# Se guarda en $a0 el entero solicitado
		
		jal translateInstruction		# Se ejecuta la función que realiza la traducción de la función
		
		la $a0, jumpLine				
		li $v0, 4						
		syscall
		
		# ENTREGABLE 3
		
		la $a0, cesarEncodeText1		# Se muestra el texto de solicitud de mensaje
		li $v0, 4
		syscall
		
		la $a0, defaultString			# Se guarda en $a0 la dirección de la cadena sin codificar
		li $a1, 20						# Se establece $a1 en 20, máximo tamaño de la cadena
		
		li $v0, 8						# Solicito el string al usuario
		syscall
		
		jal changeEndLine				# Se ejecuta la función para cambiar el caracter fin de linea \n a \0 (caracter nulo)
		
		la $a0, cesarEncodeText2
		li $v0, 4
		syscall
		
		li $v0, 5						# Se solicita al usuario la clave
		syscall
		
		add $a1, $v0, $0				# Se guarda en $a1 la clave introducida por el usuario que se guardó en $v0
		la $a0, defaultString			# Se almacena en $a0 y $a2 las direcciones de la cadena sin codificar y codificada
		la $a2, encodedString
		
		jal cesarEncode					# Se ejecuta la función de codificación cesar
		
		la $a0, encodedString
		li $v0, 4
		syscall
		
		li $v0, 10
		syscall
		
		
	sumEvens:
						
		addi $v0, $0, 0					# Se inicializa $v0 que sera el resutlado de la suma en 0
			
		sumEvensLoop:
			add $v0, $v0, $t2			# Se suma $t2 (2) a $v0
			addi $t2, $t2, 2			# Se suma 2 a $t2 (ahora es 4, en la siguiente iteración 6...	)
			ble $t2, $a0, sumEvensLoop	# Si $t2, que corresponde con los nºs pares, es menor o igual
										# que el entero introducido, se realizará otra iteración del bucle
		jr $ra					
		
	printRegister:
		add $t0, $0, $a0				# En $a0 estan guardados los 5 bits correspondientes a lo que se quiere traducir
										# Se pasa dicho valor a $t0, para guardarlo como auxiliar
		blt $t0, 0, printRegisterError	# Si el número no se encuentra entre 0 y 31, no corresponde a un nº de 
		bgt $t0, 31, printRegisterError	# registro y por tanto no se puede traducir
		
		la $a0, printRegisterDollarText	# Se muestra por pantalla el $
		li $v0, 4
		syscall		
		
		lb $a0, 0($a0)					# Se obtiene el primer byte de $a0 para obtener el simbolo de $
		sb $a0, -9($sp)					# Se guarda el simbolo $ en la pila
		
		beq $t0, 0, printZero			# Se hacen comparaciones del valor de los 5 bits para obetener el registro
		beq $t0, 1, printAt				# que tiene que imprimirse
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
			la $a0, printRegisterZeroText	# Se imprime (zero), y va a ser igual para todos los registros
			li $v0, 4
			syscall
			
			lw $a0, 0($a0)					# Se obtienen los primeros 4 bytes de $a0 para obtener el registro correspondiente
			sw $a0, -8($sp)					# Se guarda el registro en la pila
			
			j endPrintRegister			
		printAt:
			la $a0, printRegisterAtText
			li $v0, 4
			syscall
			
			lh $a0, 0($a0)
			sw $a0, -8($sp)
			
			j endPrintRegister
		
		printV:
			# (todo este proceso se realiza repetidas veces, por lo que solo lo dejare comentado aquí)
			la $a0, printRegisterVText
			li $v0, 4
			syscall
			
			lb $a0, 0($a0)
			sw $a0, -8($sp)				# Se guarda en la posición -8 de la pila el texto del registro (v)
			
			addi $t0, $t0, -2			# Se resta 2 a $t0 para que cuadre el valor con el número correspondiente de $v
			
			add $a0, $0, $t0			
			li $v0, 1
			syscall
			
			sw $a0, -4($sp)				# Se guarda en la posición -4 de la pila el número del registro
			
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
			
			li $v0, 1		# En caso de existir algún error, la función devolverá 1
			j exitPrintRegister
			
		endPrintRegister:
			li $v0, 0		# En caso de que todo haya ido bien, la funcion devuelve 0
			
			exitPrintRegister:
			
				jr $ra
		
	translateInstruction:
		add $t1, $0, $a0						# Se guarda en $t1 el entero
		
		sw $ra, 0($sp)							# Se guarda el $ra en $sp porque se llama a otra función
		
		la $a0, translateInstructionText1		# Se guarda en $a0 el texto a imprimir (Código de operación: )
		li $v0, 4								# Se muestra por pantalla el texto
		syscall
		
		srl $a0, $t1, 26						# Se guarda en $a0 el valor del código de operación 
		li $v0, 1
		syscall
		
		bne $a0, $0, translateInstructionError	# Si el código de operación no es 0, imprime por pantalla que no es de tipo R
												# y por tanto no traduce el número en el código de instrucciones
		la $a0, translateInstructionText2
		li $v0, 4
		syscall
		
		la $a0, jumpLine
		li $v0, 4
		syscall
		
		la $a0, translateInstructionText3		# Se imprime (Registros utilizados: rs = )...
		li $v0, 4
		syscall
		
		sll $a0, $t1, 6							# Se desplaza el entero introducido hacia la izquierda para eliminar el código 
		srl $a0, $a0, 27						# de operación, y a la derecha para quedarnos únicamente con lo que corresponde a rs	
								
		jal printRegister						# Se llama a la función que muestra el registro
		
		lb $t2, -9($sp)							# Se pasa los datos guardados en la pila a la dirección de $a1
		sb $t2, 0($a1)
		lw $t2, -8($sp)
		sw $t2, 4($a1)
		lw $t2, -4($sp)
		sw $t2, 8($a1)
		
		la $a0, translateInstructionText4
		li $v0, 4
		syscall
		
		sll $a0, $t1, 11						# Se mueve $t1 los valores correspondientes para quedarse con la parte del registro que toca
		srl $a0, $a0, 27
		
		jal printRegister
		
		lb $t2, -9($sp)							# Se pasa los datos guardados en la pila a la dirección de $a2
		sb $t2, 0($a2)
		lw $t2, -8($sp)
		sw $t2, 4($a2)
		lw $t2, -4($sp)
		sw $t2, 8($a2)
		
		la $a0, translateInstructionText5
		li $v0, 4
		syscall
		
		sll $a0, $t1, 16						# Se mueve $t1 los valores correspondientes para quedarse con la parte del registro que toca
		srl $a0, $a0, 27
		
		jal printRegister
		
		lb $t2, -9($sp)							# Se pasa los datos guardados en la pila a la dirección de $a3
		sb $t2, 0($a3)
		lw $t2, -8($sp)
		sw $t2, 4($a3)
		lw $t2, -4($sp)
		sw $t2, 8($a3)
		
		li $v0, 0								# En caso de que todo vaya bien, la función devuelve 0
		
		exitTranslateInstruction:
			lw $ra, 0($sp)						# Se recupera el $ra antiguo de la pila para poder hacer el salto correctamente
			jr $ra
			
		translateInstructionError:
			la $a0, translateInstructionText6
			li $v0, 4
			syscall
			
			li $v0, 1							# En caso de que haya algún error, la función devuelve 1
			
			j exitTranslateInstruction
	
	changeEndLine:
		add $t0, $0, $0
		
		# Bucle que carga byte a byte de $a0 y cuando encuentra caracter salto de linea (10) intercambia el valor por un 0 de caracter nulo
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
		
		bgt $a1, 100, cesarEncodeError1 		# Si la clave es mayor que 100 o menor o igual que 0 el programa debe mostrar un error
		ble $a1, 0, cesarEncodeError1
		
		# Se recorre la cadena sumando el valor correspondiente de $a1 a cada caracter
		# En caso de que se pase de los caracteres imprimibles, muestra el error correspondiente
		
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
			
			