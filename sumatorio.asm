.data 
   string_resultado: .asciiz "Resultado: "
   string_pedir: .asciiz "Introduce un digito: "
   string_error: .asciiz "Error: el numero debe estar entre 1 y 99"
.text

  main:

   # $t0 -> numero
   # $t1 -> 1
   # $t2 -> 99
   # $t3 -> iterador
   # $t4 -> resultado
   
   # IMPRIMIR STRING
   # la | syscall 4
   
   la   $a0, string_pedir
   li   $v0, 4
   syscall

   # LEER NUMERO
   # syscall 5 
   li   $v0, 5      # load inmediate 5
   syscall

   # En este momento, tenemos el inmediato que el 
   # usuario ha introducido en $v0
 
   move $t0, $v0    # paso el valor de $v0 -> $t0 
                  # para poder operar con el
   
   # COMPROBAR 1 < numero < 99

   # blt | bgt
   li   $t1, 1
   li   $t2, 99

   blt  $t0, $t1, Error    # En caso de que $t0 < $t1, vamos a Error
   bgt  $t0, $t2, Error    # En caso de que $t0 > $t1, vamos a Error
 
   # Si estamos aqui, es porque todo ha ido bien
 
   # BUCLE PARA EL SUMATORIO
 
   # Tenemos que tener un contador que sera la i que vaya sumando
   li   $t3, 1

   # Tenemos que tener un resultado que sera donde se iran
   # guardando las sumas parciales
   li   $t4, 0

   Bucle:
   
    add  $t4, $t4, $t3    # res = res + i
    add  $t3, $t3, $t1    # i = i + 1
    # addi $t3, $t3, 1 tambien hubiera sido valido

    bge  $t0, $t3, Bucle  # mumero >= i ? Si: Bucle No: continua

   # Si estamos aqui, es porque ya hemos completado el sumatorio
 
   # MOSTRAR EL RESULTADO
 
   # la | syscall 4 | syscall 1

   la   $a0, string_resultado  # load address
   li   $v0, 4     # para imprimir la cadena
   syscall

   # Ahora tengo en la terminal: "Resultado: "
   # Ahora toca imprimir el inmediato resultado
   # Para ello, el numero debe estar en $a0
 
   move $a0, $t4   # $a0 <- resultado
   li   $v0, 1     # para imprimir el inmediato
   syscall
 
   # Ahora en la terminal ya tengo "Resultado: `x`"
 
   Fin:
     # FINALIZAR EL PROGRAMA
     # syscall 10
 
     li   $v0, 10
     syscall
   
   Error:
     la   $a0, string_error
     li   $v0, 4
     syscall
     j    Fin
