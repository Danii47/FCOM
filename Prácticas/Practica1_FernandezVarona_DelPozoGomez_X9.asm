# $s0 -> Dirección de A
# $s1 -> Contador
# $s2 -> Suma
# $s3 -> Media aritmética

# $s4 -> Dirección de B
# $s5 -> Dirección de C
# $s6 -> Dirección de A (para recorrerlo del derecho)


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
		la $s0, A # Carga la dirección de A en $s0
		add $s6, $s0, $0 # Dejo $s6 en la dirección de $s0 para recorrerlo del derecho
		
		addi $s0, $s0, 36 # $s0 en 36 para recorrer el vector al revés

		add $s1, $0, $0 # Deja el registro $s1 a 0 (contador)
		add $s2, $0, $0 # Deja el registro $s2 a 0 (suma)
		add $s3, $0, $0 # Deja el registro $s3 a 0 (media aritmetica)

		la $s4, B
		la $s5, C

		addi $t2, $0, 2
		
	Loop:
		
		lw $t0, ($s0) # Carga el valor de $s0 en $t0 (recorriendolo al revés)
		
		div $t0, $t2 # Divido el valor del vector entre 2
		mfhi $t3 # $t3 de dividir el valor entre 2 (0 -> PAR | 1 -> IMPAR)
		
		beq $t3, 0, ACopy
		beq $t3, 1, BCopy
		
		LoopContinuation:
			
			addi $s0, $s0, -4 # Sumo 4 a la dirección del registro para poder acceder al siguiente elemento
			
			
			add $s2, $s2, $t0 # Suma $s2 + $t0
			addi $s1, $s1, 1 # Suma el valor inmediato 1 a $s1
			
			
			bne $s1, 10, Loop # Si $s1 es distinto de 10, salta a Loop
		
			div $s3, $s2, $s1 

			
	la $s0, A # Carga la dirección de A en $s0
	addi $s0, $s0, 36 # $s0 en 36 para recorrer el vector al revés
	
	AlternateValuesLoop:
		lw $t0, ($s0) # Carga el valor de $s0 en $t0 (recorriendolo al revés)
		lw $t1, ($s6) # Carga el valor de $s6 en $t1 (recorriendolo del derecho)
		ble $t4, 5, AlternateValues
	
	
	la $s6, S1      # Carga la dirección de S1
	addi $s6, $s6, 17	# Apuntamos al final de la cadena
	
	la $s7, S2		# Carga la dirección de S2
	
	lb $t1, 0($s6)		# Carga en $t1 la cadena al revés
	sb $t1, 0($s7)	
	
	reverseString:

	
	
	
		lb $t4, 0($s5)
	
		addi $s6, $s6, -1
		addi $s7, $s7, 1	
	
		lb $t1, 0($s6)		#Carga en $t1 la cadena al revés
		sb $t1, 0($s7)	
	
		bne $t1, $0, reverseString
		

	la $s6, S1
	la $s0, S3
	addi $t1, $0, 1 # Número de palabra recorrida en S1
	lb $t3, 0($s6)
	
	SaveOddS3:
		
		
		
		beq $t3, 32, AddWordS1

		andi $t4, $t1, 1
		bne $t4, 1, ContinueS3
		
		sb $t3, 0($s0)
		addi $s0, $s0, 1
		
		ContinueS3:
			addi $s6, $s6, 1
			lb $t3, 0($s6)
			bne $t3, $0, SaveOddS3
	
	
	la $s6, S2
	la $s0, S4
	addi $t1, $0, 1 # Número de palabra recorrida en S2
	lb $t3, 0($s6)
	
	SaveOddS4:
	
		
		
		beq $t3, 32, AddWordS2

		andi $t4, $t1, 1
		bne $t4, 1, ContinueS4
		
		sb $t3, 0($s0)
		addi $s0, $s0, 1
	
		ContinueS4:
			addi $s6, $s6, 1
			lb $t3, 0($s6)
			bne $t3, $0, SaveOddS4
		
	la $a0, S1Text
	li $v0, 4
	syscall
	
	la $a0, S1
	li $v0, 4
	syscall
	
	la $a0, LineJump
	li $v0, 4
	syscall
	
	la $a0, S2Text
	li $v0, 4
	syscall


	la $a0, S2
	li $v0, 4
	syscall
	
	la $a0, LineJump
	li $v0, 4
	syscall
	
	la $a0, S3Text
	li $v0, 4
	syscall
	
	la $a0, S3
	li $v0, 4
	syscall

	la $a0, LineJump
	li $v0, 4
	syscall
	
	la $a0, S4Text
	li $v0, 4
	syscall
	
	la $a0, S4
	li $v0, 4
	syscall
	
	li $v0 10 # Cierra el programa
	syscall
	
AddWordS1:
	addi $t1, $t1, 1
	j ContinueS3
	
AddWordS2:
	addi $t1, $t1, 1
	j ContinueS4
	
ACopy:
	sw $t0 ($s4)
	addi $s4, $s4, 4
	j LoopContinuation
	
BCopy:
	sw $t0 ($s5)
	addi $s5, $s5, 4
	j LoopContinuation
		
AlternateValues:
	sw $t0, ($s6)
	sw $t1, ($s0)
	addi $s6, $s6, 4
	addi $s0, $s0, -4
	addi $t4, $t4, 1
		
	j AlternateValuesLoop
		
# A la vista de lo observado en el paso anterior: ¿Cuál es el propósito del programa? ¿Cuántas iteraciones
# realiza? Cuando se observa la consola (en la parte inferior, pestaña Run I/O) ¿Por qué el programa no
# muestra nada tras su ejecución?
# El propósito del programa es sumar los 10 números del vector A
# Realiza 10 iteraciones y suma 88
# No muestra nada porque el programa no está mandando nada a la salida de la consola, solo alterando los registros
