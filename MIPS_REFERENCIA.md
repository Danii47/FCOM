
# HOJA DE REFERENCIA MIPS

## Indice
- [HOJA DE REFERENCIA MIPS](#hoja-de-referencia-mips)
- [Indice](#indice)
- [Tipos de registros](#tipos-de-registros)
- [Registros extra](#registros-extra)
- [Funciones de entrada/salida (Syscall)](#funciones-de-entradasalida-syscall)
- [Instrucciones](#instrucciones)
- [Ejemplos de instrucciones](#ejemplos-de-instrucciones)

---

## Tipos de registros

| Número | Registro | Descripción |
| - | - | - |
| 0 | **\$zero** | Siempre contiene el valor 0 |
| 1 | \$at | Reservado para el ensamblador |
| 2-3 | **\$v0-$v1** | Valores de retorno de las funciones |
| 4-7 | **\$a0-$a3** | Argumentos de las funciones |
| 8-15 | **\$t0-$t7** | Temporales (no preservados) |
| 16-23 | **\$s0-$s7** | Temporales (preservados) |
| 24-25 | **\$t8-$t9** | Temporales (no preservados) |
| 26-27 | \$k0-$k1 | Reservados para el kernel |
| 28 | $gp | Puntero global (Global Pointer) |
| 29 | $sp | Puntero de pila (Stack Pointer) |
| 30 | $fp | Puntero de marco (Frame Pointer) |
| 31 | **$ra** | Dirección de retorno (Return Address) |

---

## Registros extra
| Número | Registro | Descripción |
| - | - | - |
| 0-31 | \$f0-$f31 | Reservados para valores float y double |

---

## Funciones de entrada/salida (Syscall)

**Para que el syscall se ejecute deberemos tener en el registro `$v0` el inmediato correspondiente**

| Código | Descripción | Argumentos | Resultado |
| - | - | - | - |
| 1 | Imprimir entero | $a0 = entero | - |
| 2 | Imprimir flotante | $f12 = flotante | - |
| 3 | Imprimir doble flotante | $f12 = doble flotante | - |
| 4 | Imprimir cadena | $a0 = dirección de la cadena (terminada en el caracter nulo) | - |
| 5 | Leer entero | - | guarda el entero en $v0 |
| 6 | Leer flotante | - | guarda el flotante en $f0 |
| 7 | Leer doble flotante | - | guarda el doble flotante en $f0 |
| 8 | Leer cadena | $a0 = dirección de la cadena<br> $a1 = longitud máxima de la cadena | - |
| 10 | Terminar programa | - | - |
| 11 | Imprimir caracter | $a0 = caracter (entero ASCII del caracter) | - |

---

## Instrucciones

| Instrucción | Significado | Parámetros | Descripción | Ejemplo |
| :--- | :--- | :--- | :--- | :--- |
| **la** | load address | rd, Etiqueta | Carga la dirección representada por Etiqueta en el registro rd | `la $s0, A` |
| **li** | load immediate | rd, inm | Carga el valor inmediato inm en el registro rd | `li $s0, 5` |
| **lui** | load upper immediate | rd, inm | Carga el valor inmediato inm en los bits más significativos del registro rd | `lui $s0, 5` |
| **add** | add | rd, rs, rt | Suma con detección de desbordamiento: rd <- rs + rt | `add $s2, $s1, $s0` |
| **addi** | add immediate | rd, rs, inm | Suma inmediata (con signo extendido): rd <- rs + inm | `addi $s2, $s1, 5` |
| **sub** | subtract | rd, rs, rt | Resta con detección de desbordamiento: rd <- rs - rt | `sub $s2, $s1, $s0` |
| **lw** | load word | rd, d(rs) | Lee el contenido de rs + d (desplazamiento) y lo carga en rd | `lw $t1, 0($t0)` |
| **sw** | store word | rt, d(rs) | Almacena el contenido de rt en la dirección de memoria rs + d | `sw $t1, 4($t0)` |
| **move** | move | rd, rs | Copia el contenido de rs en rd | `move $t2, $t1` |
| **sll** | shift left logical | rd, rt, d | Desplaza a la izquierda el contenido de rt d veces y lo almacena en rd | `sll $t2, $t1, 2` |
| **slt** | set less than | rd, rs, rt | Establece rd en 1 si rs < rt, de lo contrario, establece rd en 0 | `slt $t2, $t1, $t0` |
| **slti** | set less than immediate | rd, rs, inm | Establece rd en 1 si rs < inm (con signo extendido), de lo contrario, 0 | `slti $t2, $t1, 5` |
| **beq** | branch equal | rs, rt, Etiqueta | Salta a la instrucción en Etiqueta si rs == rt | `beq $t1, $t2, L1` |
| **bne** | branch not equal | rs, rt, Etiqueta | Salta a la instrucción en Etiqueta si rs != rt | `bne $t1, $t2, L1` |
| **ble** | branch less or equal | rs, rt, Etiqueta | Salta a la instrucción en Etiqueta si rs <= rt | `ble $t1, $t2, L1` |
| **blt** | branch less than | rs, rt, Etiqueta | Salta a la instrucción en Etiqueta si rs < rt | `blt $t1, $t2, L1` |
| **bge** | branch greater or equal | rs, rt, Etiqueta | Salta a la instrucción en Etiqueta si rs >= rt | `bge $t1, $t2, L1` |
| **bgt** | branch greater than | rs, rt, Etiqueta | Salta a la instrucción en Etiqueta si rs > rt | `bgt $t1, $t2, L1` |
| **j** | jump | Etiqueta | Salta a la instrucción en la dirección representada por Etiqueta | `j L1` |
| **jal** | jump and link | Etiqueta | Salta a la instrucción en Etiqueta y guarda la dirección de retorno en $ra | `jal L1` |
| **jr** | jump register | rs | Salta a la dirección de memoria contenida en rs | `jr $ra` |
| **jalr** | jump and link register | rd, rs | Salta a la dirección de memoria en rs y guarda la dirección de retorno en rd | `jalr $t1, $ra` |
----

## Ejemplos de instrucciones

> [!TIP]
> La instrucción `la` (_`Load Address`_) carga la dirección de memoria representada por la etiqueta `A` (Ej: un vector) en el registro `$s0`.  
>
> **Ejemplo ASM:**
> ```asm
> la $s0, A
> ```

----

> [!TIP]
> La instrucción `li` (_`Load Inmediate`_) carga el valor inmediato `5` en el registro `$s0`.
>
> **Ejemplo ASM:**
> ```asm
> li $s0, 5
> ```
> *También puede usarse para cargar un valor negativo.*

----

> [!TIP]
> La instrucción `lui` (_`Load Upper Inmediate`_) carga el valor inmediato `5` en los bits más significativos del registro `$s0`.
>
> **Ejemplo ASM:**
> ```asm
> lui $s0, 5
> ```
> *También puede usarse para cargar un valor negativo.*

----

> [!TIP]
> La instrucción `add` (_`ADD`_) suma los valores de los registros `$s1` y `$s0` y almacena el resultado en el registro `$s2`.  
>
> *También puede usarse para "copiar" el valor de un registro a otro sumandole $zero.*  
> 
> **Ejemplo ASM:**
> ```asm
> add $s2, $s1, $s0
> ```

----

> [!TIP]
> La instrucción `addi` (_`ADD inmediate`_) suma el valor inmediato `x` (Ej: 10) al valor del registro `$s1` y almacena el resultado en el registro `$s2`.  
> Que sea con signo extenido significa que si el valor inmediato es negativo, se extiende el bit de signo para que el valor sea negativo. 
>  
> **Ejemplo ASM:**
> ```asm
> addi $s2, $s1, 10
> ```

----

> [!TIP]
> La instrucción `sub` (_`SUBtraction`_) resta los valores de los registros `$s1` y `$s0` y almacena el resultado en el registro `$s2`. 
>  
> **Ejemplo ASM:**
> ```asm
> sub $s2, $s1, $s0
> ```

----

> [!TIP]
> La instrucción `lw` (_`Load Word`_) carga la palabra en la dirección de memoria contenida en el registro `$t1` en el registro `$t2`. El desplazamiento es `0`, por lo que se carga la palabra exactamente en la dirección contenida en `$t1`.
> 
> *Puede ser útil para cargar un valor de un vector en un registro.*
> 
> **Ejemplo ASM:**
> ```asm
> lw $t1, 0($t0)
> ```

----

> [!TIP]
> La instrucción `sw` (_`Store Word`_) almacena el contenido del registro `$t1` en la dirección de memoria contenida en el registro `$t0`. El desplazamiento en el ejemplo es `4`, por lo que se almacena el contenido de `$t1` en la dirección `$t0 + 4`.
>
> *Puede ser útil para almacenar un valor en una posición de un vector vector.*
>
> **Ejemplo ASM:**
> ```asm
> sw $t1, 4($t0)
> ```

----

> [!TIP]
> La instrucción `move` (_`MOVE`_) copia el contenido del registro `$t1` en el registro `$t2`.
>
> *Puede ser útil para copiar el contenido de un registro a otro.*
> 
> **En Python / JavaScript:**
> ```py
> t2 = t1
> ```
> **Ejemplo ASM:**
> ```asm
> move $t2, $t1
> ```
> **Otra forma equivalente sin usar move:**
> ```asm
> add $t2, $zero, $t1
> ```

----

> [!TIP]
> La instrucción `sll` (_`Shift Left Logical`_) desplaza el contenido del registro `$t1` un `d` posiciones a la izquierda y almacena el resultado en el registro `$t2`.
> 
> Esto, en la prácica, es equivalente a multiplicar el contenido de `$t1` por 2^d^.
>
> **Ejemplo ASM:**
> ```asm
> # $t1 00011 (3 en binario)
> sll $t2, $t1, 2
> # $t2 01100 (12 en binario; 3 * 2^2 = 12)
> ```

----

> [!TIP]
> La instrucción `slt` (_`Set on Less Than`_) establece el valor del registro `$t2` en 1 si el valor del registro `$t1` es menor que el valor del registro `$t0`, de lo contrario, establece el valor del registro `$t2` en 0. 
>  
> **En Python:**
> ```py
> t2 = 1 if t1 < t0 else 0
> ```
> **En JavaScript:**
> ```js
> t2 = (t1 < t0) ? 1 : 0
> ```
> **Ejemplo ASM:**
> ```asm
> # $t1 = 5, $t0 = 3
> slt $t2, $t1, $t0
> # $t2 = 0 (5 no es menor que 3)
> ```

----

> [!TIP]
> La instrucción `slti` (_`Set on Less Than Inmediate`_) establece el valor del registro `$t2` en 1 si el valor del registro `$t1` es menor que el valor inmediato `x`, de lo contrario, establece el valor del registro `$t2` en 0.  
> 
> Funciona igual que `slt`, pero en lugar de comparar con el valor de otro registro, compara con un valor inmediato.
>
> **Ejemplo ASM:**
> ```asm
> # $t1 = 2
> slti $t2, $t1, 3
> # $t2 = 1 (2 es menor que 3)
> ```

----

> [!TIP]
> La instrucción `beq` (_`Branch if EQual`_) salta a la etiqueta `L1` si el contenido de los registros `$t1` y `$t2` son iguales.
>
> *Puede ser útil para implementar un bucle.*
>
> **Ejemplo ASM:**
> ```asm
> beq $t1, $t2, Loop
> ```

----

> [!TIP]
> La instrucción `bne` (_`Branch if Not Equal`_) salta a la etiqueta `L1` si el contenido de los registros `$t1` y `$t2` no son iguales.  
> *Es el contrario a beq*.  
> 
> *Puede ser útil para implementar un bucle.*
>
> **Ejemplo ASM:**
> ```asm
> bne $t1, $t2, Loop
> ```

----

> [!TIP]
> La instrucción `ble` (_`Branch if Less or Equal`_) salta a la etiqueta `L1` si el contenido de los registro `$t1` es menor o igual al contenido de `$t2`.
>
> **Ejemplo ASM:**
> ```asm
> ble $t1, $t2, Loop
> ```

----

> [!TIP]
> La instruccion `blt` (_`Branch if Less Than`_) salta a la etiqueta `L1` si el contenido de los registro `$t1` es menor al contenido de `$t2`.
>
> **Ejemplo ASM:**
> ```asm
> blt $t1, $t2, Loop
> ```

----

> [!TIP]
> La instrucción `bge` (_`Branch if Greater or Equal`_) salta a la etiqueta `L1` si el contenido de los registro `$t1` es mayor o igual al contenido de `$t2`.
>
> **Ejemplo ASM:**
> ```asm
> bge $t1, $t2, Loop
> ```

----

> [!TIP]
> La instrucción `bgt` (_`Branch if Greater Than`_) salta a la etiqueta `L1` si el contenido de los registro `$t1` es mayor al contenido de `$t2`.
>
> **Ejemplo ASM:**
> ```asm
> bgt $t1, $t2, Loop
> ```
----

> [!TIP]
> La instrucción `j` (_`Jump`_) salta a la etiqueta `L1` sin condición alguna.
>
> **Ejemplo ASM:**
> ```asm
> j Loop
> ```

----

> [!TIP]
> La instrucción `jal` (_`Jump And Link`_) salta a la etiqueta `L1` y guarda la dirección de retorno en el registro `$ra`. 
>
> **Ejemplo ASM:**
> ```asm
> jal Loop
> ```

----

> [!TIP]
> La instrucción `jr` (_`Jump Register`_) salta a la dirección de memoria contenida en el registro `$ra`.
>
> **Ejemplo ASM:**
> ```asm
> jr $ra
> ```

----

> [!TIP]
> La instrucción `jalr` (_`Jump And Link Register`_) salta a la dirección de memoria contenida en el registro `$ra` y guarda la dirección de retorno en el registro `$t1`.
>
> **Ejemplo ASM:**
> ```asm
> jalr $t1, $ra
> ```

> **Ejemplo de programa**
>
> Pide un numero al usuario y realiza el sumatorio hasta ese número. <br>
> *Restricción: 1 < número < 99* <br>
> ```asm
> .data 
>    string_resultado: .asciiz "Resultado: "
>    string_error: .asciiz "Error: el numero debe estar entre 1 y 99"
>
> .text
>
>  main:
>
>   # $t0 -> numero
>   # $t1 -> 1
>   # $t2 -> 99
>   # $t3 -> iterador
>   # $t4 -> resultado
>
>   # LEER NUMERO
>   # syscall 5 
>   li   $v0, 5      # load inmediate 5
>   syscall
>
>   # En este momento, tenemos el inmediato que el 
>   # usuario ha introducido en $v0
>   
>   move $t0, $v0    # paso el valor de $v0 -> $t0 
>                    # para poder operar con el
>   
>   # COMPROBAR 1 < numero < 99
>
>   # blt | bgt
>   li   $t1, 1
>   li   $t2, 99
>
>   blt  $t0, $t1, Error    # En caso de que $t0 < $t1, vamos a Error
>   bgt  $t0, $t2, Error    # En caso de que $t0 > $t1, vamos a Error
>   
>   # Si estamos aquí, es porque todo ha ido bien
>   
>   # BUCLE PARA EL SUMATORIO
>   
>   # Tenemos que tener un contador que será la i que vaya sumando
>   li   $t3, 1
>
>   # Tenemos que tener un resultado que será donde se iran
>   # guardando las sumas parciales
>   li   $t4, 0
>
>   Bucle:
>     
>     add  $t4, $t4, $t3    # res = res + i
>     add  $t3, $t3, $t1    # i = i + 1
>     # addi $t3, $t3, 1 tambien hubiera sido valido
> 
>     bge  $t0, $t3, Bucle  # mumero >= i ? Si: Bucle No: continua
>
>   # Si estamos aquí, es porque ya hemos completado el sumatorio
>   
>   # MOSTRAR EL RESULTADO
>   
>   # la | syscall 4 | syscall 1
> 
>   la   $a0, string_resultado  # load address
>   li   $v0, 4     # para imprimir la cadena
>   syscall
> 
>   # Ahora tengo en la terminal: "Resultado: "
>   # Ahora toca imprimir el inmediato resultado
>   # Para ello, el numero debe estar en $a0
>   
>   move $a0, $t4   # $a0 <- resultado
>   li   $v0, 1     # para imprimir el inmediato
>   syscall
>   
>   # Ahora en la terminal ya tengo "Resultado: `x`"
>
>   Fin:
>     # FINALIZAR EL PROGRAMA
> 
>     # syscall 10
>   
>     li   $v0, 10
>     syscall
>
>   Error:
>     la   $a0, string_error    # load address
>     li   $v0, 4     # para imprimir la cadena
>     syscall
>     j    Fin        # Salta a la etiqueta Fin
> ```