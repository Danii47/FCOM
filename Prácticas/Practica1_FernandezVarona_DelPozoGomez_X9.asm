.data
	A: .word 0, 1, 1, 2, 3, 5, 8, 13, 21, 34
	B: .space 40
	C: .space 40
	S1: .asciiz "Hola Uno Mundo Dos"
	S2: .space 50
	S3: .space 50
	S4: .space 50
	LineJump: .asciiz "\n"
	S1Text: .asciiz "S1: "
	S2Text: .asciiz "S2: "
	S3Text: .asciiz "S3: "
	S4Text: .asciiz "S4: "
.text
	main:
		la $s0, A 					# Carga la direcci�n de A en $s0
		add $s6, $s0, $0 				# Dejo $s6 en la direcci�n de $s0 para recorrerlo del derecho
		
		addi $s0, $s0, 36 				# $s0 en 36 para recorrer el vector al rev�s

		add $s1, $0, $0 				# Deja el registro $s1 a 0 (contador)
		add $s2, $0, $0					# Deja el registro $s2 a 0 (suma)
		add $s3, $0, $0 				# Deja el registro $s3 a 0 (media aritmetica)

		la $s4, B					# Carga la direcci�n de B en $s4
		la $s5, C					# Carga la direcci�n de C en $s5

		addi $t2, $0, 2					# Fijamos el valor 2 a $t2 para dividir entre dos para determinar si es par o impar
		
	Loop:
		
		lw $t0, ($s0) 					# Carga el valor de $s0 en $t0 (recorriendolo al rev�s)
		
		div $t0, $t2					# Divido el valor del vector entre 2
		mfhi $t3 					# $t3 de dividir el valor entre 2 (0 -> PAR | 1 -> IMPAR)
		
		beq $t3, 0, ACopy				# Si es 0 el n�mero es par
		beq $t3, 1, BCopy				# Si es 1 el n�mero es impar
		
		LoopContinuation:
			
			addi $s0, $s0, -4 			# Sumo 4 a la direcci�n del registro para poder acceder al siguiente elemento
						
			add $s2, $s2, $t0 			# Suma $s2 + $t0
			addi $s1, $s1, 1 			# Suma el valor inmediato 1 a $s1			
			
			bne $s1, 10, Loop			# Si $s1 es distinto de 10, salta a Loop
		
			div $s3, $s2, $s1 			# Guarda es $s3 la media aritm�tica de la suma ($s2) entre el n�mero de valores ($s1)
			
	la $s0, A 						# Carga la direcci�n de A en $s0
	addi $s0, $s0, 36 					# $s0 en 36 para recorrer el vector al rev�s
	
	AlternateValuesLoop:
		lw $t0, ($s0) 					# Carga el valor de $s0 en $t0 (recorriendolo al rev�s)
		lw $t1, ($s6) 					# Carga el valor de $s6 en $t1 (recorriendolo del derecho)
		ble $t4, 5, AlternateValues			# Guarda 5 valores del derecho y 5 del rev�s, por lo tanto,
								# cuando llega a 5 se han guardado los 10 n�meros
								
	la $s6, S1      					# Carga la direcci�n de S1
	addi $s6, $s6, 17					# Apuntamos al final de la cadena
	
	la $s7, S2						# Carga la direcci�n de S2
	
	lb $t1, 0($s6)						# Carga en $t1 la cadena al rev�s
	sb $t1, 0($s7)						# Guarda en $s7 el registro $t1 que contiene la cadena del rev�s
	
	reverseString:
	
		lb $t4, 0($s5)					# Carga el byte de la cadena almacenada en $s5 en el registro $t4	
	
		addi $s6, $s6, -1				# Avanza hacia del rev�s en la cadena ($s6) 								
		addi $s7, $s7, 1				# y del derecho en la cadena invertida ($s7)
	
		lb $t1, 0($s6)					# Carga en $t1 la cadena al rev�s
		sb $t1, 0($s7)					# Almacena el byte de la cadena al rev�s
	
		bne $t1, $0, reverseString			# Si el byte cargado es diferente de cero, significa que 
								# todav�a hay caracteres en la cadena
								
	la $s6, S1						# Reasigna $s6 
	la $s0, S3						# Reasigna $s0
	addi $t1, $0, 1 					# Inicializa el n�mero de palabra recorrida
	lb $t3, 0($s6)						# Caga en $t3 el registro $s6
	
	SaveOddS3:
		
		beq $t3, 32, AddWordS1				# Comprueba si el byte de $t3 es un espacio (' ')

		andi $t4, $t1, 1				# Comprueba si el n�mero de palabra recorrida en $t1 es impar
		bne $t4, 1, ContinueS3
		
		sb $t3, 0($s0)					# Si el n�mero de palabra es impar, almacena el byte en la 
		addi $s0, $s0, 1				# posici�n de memoria que marca $s0
		
		ContinueS3:					
			addi $s6, $s6, 1			# Avanza un byte en $s6
			lb $t3, 0($s6)				# Carga en $t3 el byte de $s6
			bne $t3, $0, SaveOddS3			# Si el byte cargado no es cero, significa que sigue habiendo caracteres
			
	la $s6, S2						# Reasigna $s6 
	la $s0, S4						# Reasigna $s0
	addi $t1, $0, 1 					# N�mero de palabra recorrida en S2
	lb $t3, 0($s6)						# Caga en $t3 el registro $s6
	
	SaveOddS4:
	
		beq $t3, 32, AddWordS2				# Comprueba si el byte de $t3 es un espacio (' ')

		andi $t4, $t1, 1				# Comprueba si el n�mero de palabra recorrida en $t1 es impar
		bne $t4, 1, ContinueS4
		
		sb $t3, 0($s0)					# Si el n�mero de palabra es impar, almacena el byte en la 
		addi $s0, $s0, 1				# posici�n de memoria que marca $s0
	
		ContinueS4:
			addi $s6, $s6, 1			# Avanza un byte en $s6
			lb $t3, 0($s6)				# Carga en $t3 el byte de $s6
			bne $t3, $0, SaveOddS4			# Si el byte cargado no es cero, significa que sigue habiendo caracteres
	
	
	# Imprime por la terminal los valores de s1 s3 y s4
		
	la $a0, S1Text						# Imprime "S1: " 
	li $v0, 4
	syscall
	
	la $a0, S1						# Imprime la cadena de $s1
	li $v0, 4						
	syscall
	
	la $a0, LineJump					# Cambio de linea 
	li $v0, 4
	syscall
	
	la $a0, S2Text						# Imprime "S2: " 
	li $v0, 4
	syscall


	la $a0, S2						# Imprime la cadena de $s2
	li $v0, 4
	syscall
	
	la $a0, LineJump					# Cambio de linea
	li $v0, 4
	syscall
	
	la $a0, S3Text						# Imprime "S3: " 
	li $v0, 4
	syscall
	
	la $a0, S3						# Imprime la cadena de $s3
	li $v0, 4
	syscall

	la $a0, LineJump					# Cambio de linea
	li $v0, 4
	syscall
	
	la $a0, S4Text						# Imprime "S4: " 
	li $v0, 4
	syscall
	
	la $a0, S4						# Imprime la cadena de $s4
	li $v0, 4
	syscall
	
	li $v0 10 						# Cierra el programa
	syscall
	
AddWordS1:							# Avanza un byte en $t1
	addi $t1, $t1, 1					
	j ContinueS3
	
AddWordS2:							# Avanza un byte en $t1
	addi $t1, $t1, 1
	j ContinueS4
	
ACopy:
	sw  $t0 ($s4)						# Carga el valor de $t0 en $s4
	addi $s4, $s4, 4					# Suma 4 a $s4 para avanzar a la siguiente posici�n
	j LoopContinuation
	
BCopy:
	sw $t0 ($s5)						# Carga el valor de $t0 en $s5
	addi $s5, $s5, 4					# Suma 4 a $s5 para avanzar a la siguiente posici�n
	j LoopContinuation
		
AlternateValues:						# Funci�n que va guardando valores al principio y al final
	sw $t0, ($s6)
	sw $t1, ($s0)
	addi $s6, $s6, 4
	addi $s0, $s0, -4
	addi $t4, $t4, 1
		
	j AlternateValuesLoop
		
# A la vista de lo observado en el paso anterior: �Cu�l es el prop�sito del programa? �Cu�ntas iteraciones
# realiza? Cuando se observa la consola (en la parte inferior, pesta�a Run I/O) �Por qu� el programa no
# muestra nada tras su ejecuci�n?
# El prop�sito del programa es sumar los 10 n�meros del vector A
# Realiza 10 iteraciones y suma 88
# No muestra nada porque el programa no est� mandando nada a la salida de la consola, solo alterando los registros
