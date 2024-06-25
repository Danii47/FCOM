.data										# vector con números primos
	primeNumbersVector: .word 2, 3, 5, 7, 11, 13, 17, 19, 23, 29, 31, 37, 41, 43, 47, 53, 59, 61, 67, 71, 73, 79, 83, 89, 97, 0
											# vector donde se van a guardar las factorizaciones de los números
	factorizationVector: .space 200
	
	inputNumberText: .asciiz "Introduce un número: "

	errorTypeText1: .asciiz "ERROR: El número a factorizar es menor que 2."
	errorTypeText2: .asciiz "ERROR: El número introducido tiene un factor primo mayor que los considerados."
	
	printFactorsText1: .asciiz " * "
	printFactorsText2: .asciiz "^"
	printFactorsText3: .asciiz " = "
.text
	main:
		la $a0, inputNumberText				# Imprimir texto 
		li $v0, 4
		syscall
		
		li $v0, 5							# Lee un número introducido por teclado
		syscall
		
		add $s0, $v0, $0					# Guarda el número leído en $s0
		add $a0, $v0, $0					# Guarda el número leído en $a0
		
		la $a1, primeNumbersVector			# Carga el vector de primos en $a1
		la $a2, factorizationVector			# Carga el vector de la factorización
		
		
		jal factorizer						# Salta a la función que facotoriza el número
		

		bgt $v0, $0, finishProgram			# Como los códigos de error son 1 y 2, si el $v0 es mayor que 0 debe finalizar el programa
		
		# Printea "{NUMERO} = "
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

		sw $ra 0($sp)						# Guarda el ra en la pila
		addi $sp, $sp, -4					# Desplaza el puntero de la pila 4 bytes atrás

		blt $a0, 2, error1					# Si el número introducido es menor que dos, salta a error1

		lw $t0, 0($a1)						# Es caso de que no lo sea, carga en $t0, el primo de la dirección de $a1
		div $a0, $t0						# Divide el número entre el primo
		
		mfhi $t1							# Carga en $t1 el resto
		
		bne $t1, $0, notDivisor				# Si el resto no es 0, salta a notDivisor
			
		 
		sw $t0, 0($a2)						# En caso de que sea 0, significa que es divisor, y por tanto lo guarda en $a2
		
		addi $a2, $a2, 4					# Se avanza una posición en $a2
		mflo $a0							# Se actualiza el valor de $a0 al cociente
		
		
		beq $a0, 1, validEnd				# Si el cociente es uno, ha acabado de factorizar el número
		j recallFunction					# En caso de que no sea llama de nuevo a la función
			
		notDivisor: 
			addi $a1, $a1, 4				# Avanza una posición en el vector de primos
			lw $t2, 0($a1)					# Guarda en $t2 el primo
			beq $t2, $0, error2				# Si es 0, es porque ha llegado al final del vector de primos, entonces llama a error2
			
		recallFunction:
			jal factorizer					# Hace recursividad con la función
	
		exitFactorizer:
		
			addi $sp, $sp, 4
			lw $ra, 0($sp)					# Recupera el $ra de la pila
		
			jr $ra
	
		validEnd:
			li $v0, 0						# Según los resultados, guarda en $v0 lo que se pide en el enunciado
			j exitFactorizer
	
		error1:
			# Muestra el error por ser el número menor que 2
			la $a0, errorTypeText1
			li $v0, 4
			syscall
			
			li $v0, 1
			j exitFactorizer
		
		error2:
			# Muestra el error por tener factores primos mayores de los encontrados en el vector de numeros primos
			la $a0, errorTypeText2
			li $v0, 4
			syscall
		
			li $v0, 2
			j exitFactorizer


	printResult:
		addi $t2, $0, 1								# $t2 -> Contador de repeticiones del factor primo
		add $t3, $0, $a0							#  Se carga en $t3 la dirección del vector
		
		# EX�MEN: Para aplicar la modificaci�n, primeramente muevo el puntero $t3
		# a donde est� el final del vector, para posteriormente restarle 8 posiciones
		# y asi encontrarme en la direcci�n que apunta al �ltimo n�mero del vector. 
		
		searchEnd:
			lw $t0, 0($t3)
			addi $t3, $t3, 4
			bne $t0, 0, searchEnd
		
		addi $t3, $t3, -8
		
		# EX�MEN: Finalmente, el desplazamiento de 4 bytes lo hago hac�a atr�s
		# y las posiciones del vector las voy recorriendo hac�a atr�s.
		# Al estar definido el vector resultado justo despu�s del vector de primos,
		# puedo estar seguro de que cuando termine de recorrer el vector encontrar�
		# un 0, que corresponde con el 0 que se encuentra al final del vector de
		# n�meros primos. En caso de no haberme podido aprovechar de esto hubiera
		# colocado un 0 al inicio del vector resultado para poder haber hecho la
		# modificaci�n de la misma manera.
		
		printResultLoop:
			# Se observa el valor actual y el siguiente para poder comprobar si es necesario elevar (^) o no
			lw $t0, 0($t3)
			lw $t1, -4($t3)
		
			# En caso de que el número recorrido sea 0 saldrá de la función
			beq $t0, $0, exitPrintResult
		
			# Se aumenta la direccion del puntero 4 bytes
			addi $t3, $t3, -4
			
			# En caso de que el recorrido y el siguiente sean iguales se va a una etiqueta donde hará un contador
			beq $t0, $t1, numberRepeat
			
			# Printea el número correspondiente
			add $a0, $0, $t0
			li $v0, 1
			syscall
			
			# En caso de que el contador sea 1 printea solo el *
			beq $t2, 1, printSingleFactor
			# En caso contrario printea ^ y el contador
			j printMultipleFactor
		
	numberRepeat:
		addi $t2, $t2, 1
		j printResultLoop
		
	printSingleFactor:
		
		beq $t1, $0, exitPrintResult
	
		# Printea el *
		la $a0, printFactorsText1
		li $v0, 4
		syscall
		
		j printResultLoop
	
	printMultipleFactor:
		
		# Printea el ^ y el número del contador
		
		la $a0, printFactorsText2
		li $v0, 4
		syscall
		
		add $a0, $0, $t2
		li $v0, 1
		syscall
		
		# En caso de que el siguiente número sea 0 se sale de la función, si no, printea el signo *
		beq $t1, $0, exitPrintResult
		
		la $a0, printFactorsText1
		li $v0, 4
		syscall
		
		addi $t2, $0, 1
		j printResultLoop
	
	exitPrintResult:
		jr $ra
	
	
	
	
	
	
	
	
	
	
	
	
	
	
	
	
	
	
