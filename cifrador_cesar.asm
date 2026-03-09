.data 
   string_pedir_cadena: .asciiz "Introduce la cadena a cifrar: "
   string_pedir_clave:  .asciiz "Introduce la clave (numero): "
   string_resultado:    .asciiz "Resultado: "
   
   # Reservamos 256 bytes de espacio en memoria para guardar el input del usuario
   buffer_cadena:       .space 256    

.text

  main:

   # $a0 -> argumentos para los syscalls y para la funcion cifrar
   # $a1 -> argumentos extra (como la clave o tamaño maximo)
   # $v0 -> codigo de operacion para syscall
   
   # IMPRIMIR STRING "Introduce la cadena..."
   # la | syscall 4
   
   la   $a0, string_pedir_cadena
   li   $v0, 4
   syscall

   # LEER LA CADENA DEL USUARIO
   # syscall 8 
   
   la   $a0, buffer_cadena # Pasamos la direccion donde se guardara
   li   $a1, 256           # Le decimos el tamano maximo (256 caracteres)
   li   $v0, 8             # load inmediate 8 (leer string)
   syscall

   # En este momento, la cadena escrita esta en 'buffer_cadena'

   # IMPRIMIR STRING "Introduce la clave..."
   # la | syscall 4
   
   la   $a0, string_pedir_clave
   li   $v0, 4
   syscall

   # LEER NUMERO (CLAVE)
   # syscall 5 
   
   li   $v0, 5       # load inmediate 5 (leer entero)
   syscall

   # En este momento, tenemos el inmediato que el 
   # usuario ha introducido en $v0
 
   move $a1, $v0     # paso el valor de $v0 -> $a1 
                     # para pasarlo como segundo argumento a la funcion
                     
   la   $a0, buffer_cadena # $a0 sera el primer argumento (la direccion de memoria)
   
   # LLAMAR A LA FUNCION
   # jal (jump and link)
   
   jal  cifrar

   # Si estamos aqui, es porque la funcion ya ha cifrado la cadena 
   # modificando la memoria original.
 
   # MOSTRAR EL RESULTADO
 
   # la | syscall 4
   
   la   $a0, string_resultado  # load address
   li   $v0, 4     # para imprimir la cadena
   syscall

   # Ahora tengo en la terminal: "Resultado: "
   # Ahora toca imprimir la cadena ya cifrada
 
   la   $a0, buffer_cadena # $a0 <- direccion de la cadena cifrada
   li   $v0, 4     # para imprimir string
   syscall
 
   # Ahora en la terminal ya tengo "Resultado: `cadena_cifrada`"
 
   Fin:
     # FINALIZAR EL PROGRAMA
     # syscall 10
 
     li   $v0, 10
     syscall
     
     
  # ==========================================
  # FUNCION CIFRAR
  # ==========================================
  cifrar:
     # Entradas:
     # $a0 -> Direccion de la cadena
     # $a1 -> Clave (numero de desplazamientos)
     
     # Registros locales de la funcion:
     # $t0 -> Puntero iterador para la cadena
     # $t1 -> Clave normalizada (clave % 26)
     # $t2 -> Caracter actual (letra)
     # $t3 -> Base ('A' = 65 o 'a' = 97)
     # $t4 -> 26 (constante del alfabeto)
     # $t5 -> Variables temporales para comprobaciones
     
     move $t0, $a0     # Guardamos la direccion base en el iterador
     
     # Normalizamos la clave con modulo 26 (por si ponen un numero muy grande)
     li   $t4, 26
     div  $a1, $t4
     mfhi $t1          # $t1 = clave % 26
     
     # Convertir clave negativa a positiva equivalente si hiciera falta
     bgez $t1, Bucle_cifrar
     add  $t1, $t1, $t4 # Si era negativa, la "sumamos" al final del alfabeto

     Bucle_cifrar:
     
       lb   $t2, 0($t0) # Cargar el byte (letra) actual en $t2
       
       # COMPROBAR FIN DE CADENA
       beqz $t2, Fin_cifrar  # Si es 0 (null terminator), terminamos
       li   $t5, 10
       beq  $t2, $t5, Siguiente_char # Si es salto de linea (\n), lo ignoramos
       
       # COMPROBAR MAYUSCULAS (ASCII entre 65 y 90)
       li   $t5, 65
       blt  $t2, $t5, Comprobar_minuscula # Si es menor a 65, vamos a ver si es minuscula (o descartamos)
       li   $t5, 90
       bgt  $t2, $t5, Comprobar_minuscula # Si es mayor a 90, vamos a ver si es minuscula
       
       # Si estamos aqui, es una letra MAYUSCULA
       li   $t3, 65    # Su base para operar sera 65 ('A')
       j    Aplicar_algoritmo
       
       Comprobar_minuscula:
       # COMPROBAR MINUSCULAS (ASCII entre 97 y 122)
       li   $t5, 97
       blt  $t2, $t5, Siguiente_char # Si es menor a 97, es un simbolo/numero. Lo ignoramos.
       li   $t5, 122
       bgt  $t2, $t5, Siguiente_char # Si es mayor a 122, es un simbolo. Lo ignoramos.
       
       # Si estamos aqui, es una letra MINUSCULA
       li   $t3, 97    # Su base para operar sera 97 ('a')
       
       Aplicar_algoritmo:
       
       # FORMULA: (letra - base + clave) % 26 + base
       
       sub  $t2, $t2, $t3    # Le quitamos la base para que este entre 0 y 25
       add  $t2, $t2, $t1    # Le sumamos la clave
       
       div  $t2, $t4         # Lo dividimos entre 26
       mfhi $t2              # Nos quedamos con el resto (modulo) para no salirnos del abecedario
       
       add  $t2, $t2, $t3    # Le devolvemos la base ASCII
       
       # SOBRESCRIBIR LA LETRA YA CIFRADA
       sb   $t2, 0($t0)      # Guardamos el byte (store byte) en la memoria original
       
       Siguiente_char:
       
       add  $t0, $t0, 1      # Avanzamos el puntero a la siguiente casilla (letra)
       j    Bucle_cifrar     # Repetimos el bucle
       
     Fin_cifrar:
       # RETORNAR A MAIN
       jr   $ra