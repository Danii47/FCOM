
# HOJA DE REFERENCIA MIPS


## Tipos de registros

| Registro | Descripción |
| - | - |
| \$zero | Siempre contiene el valor 0 |
| \$at | Reservado para el ensamblador |
| \$v0-$v1 | Valores de retorno de las funciones |
| \$a0-$a3 | Argumentos de las funciones |
| \$t0-$t9 | Temporales (no preservados) |
| \$s0-$s7 | Temporales (preservados) |
| \$k0-$k1 | Reservados para el kernel |
| $gp | Puntero global (Global Pointer) |
| $sp | Puntero de pila (Stack Pointer) |
| $fp | Puntero de marco (Frame Pointer) |
| $ra | Dirección de retorno (Return Address) |


## Instrucciones

| Instrucción | Parámetros | Descripción | Ejemplo |
| - | - | - | - |
| la | rd, Etiqueta | Carga la dirección representada por Etiqueta en el registro rd | la $s0, A |
| add | rd, rs, rt | Suma con detección de desbordamiento: rd <- rs + rt | add $s2, $s1, $s0 |
| addi | rd, rs, inm | Suma inmediata (con signo extendido): rd <- rs + inm | addi $s2, $s1, 5 |
| sub | rd, rs, rt | Resta con detección de desbordamiento: rd <- rs - rt | sub $s2, $s1, $s0 |
| lw | rd, d(rs) | Lee el contenido de rs + d (desplazamiento) y lo carga en rd | lw $t1, 0($t0) |
| sw | rt, d(rs) | Almacena el contenido de rt en la dirección de memoria rs + d | sw $t1, 4($t0) |
| move | rd, rs | Copia el contenido de rs en rd | move $t2, $t1 |
| sll | rd, rt, d | Desplaza a la izquierda el contenido de rt d veces y lo almacena en rd | sll $t2, $t1, 2 |
| slt | rd, rs, rt | Establece rd en 1 si rs < rt, de lo contrario, establece rd en 0 | slt $t2, $t1, $t0 |
| slti | rd, rs, inm | Establece rd en 1 si rs < inm (con signo extendido), de lo contrario, establece rd en 0 | slti $t2, $t1, 5 |
| beq | rs, rt, Etiqueta | Salta a la instrucción en la dirección de memoria representada por Etiqueta si rs == rt | beq $t1, $t2, L1 |
| bne | rs, rt, Etiqueta | Salta a la instrucción en la dirección de memoria representada por Etiqueta si rs != rt | bne $t1, $t2, L1 |
| ble | rs, rt, Etiqueta | Salta a la instrucción en la dirección de memoria representada por Etiqueta si rs <= rt | ble $t1, $t2, L1 |
| blt | rs, rt, Etiqueta | Salta a la instrucción en la dirección de memoria representada por Etiqueta si rs < rt | blt $t1, $t2, L1 |
| bge | rs, rt, Etiqueta | Salta a la instrucción en la dirección de memoria representada por Etiqueta si rs >= rt | bge $t1, $t2, L1 |
| bgt | rs, rt, Etiqueta | Salta a la instrucción en la dirección de memoria representada por Etiqueta si rs > rt | bgt $t1, $t2, L1 |
| j | Etiqueta | Salta a la instrucción en la dirección de memoria representada por Etiqueta | j L1 |
| jal | Etiqueta | Salta a la instrucción en la dirección de memoria representada por Etiqueta y guarda la dirección de retorno en $ra | jal L1 |
| jr | rs | Salta a la dirección de memoria contenida en rs | jr $ra |
| jalr | rd, rs | Salta a la dirección de memoria contenida en rs y guarda la dirección de retorno en rd | jalr $t1, $ra |


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
> La instrucción `la` (_`Load Address`_) carga la dirección de memoria representada por la etiqueta `A` (Ej: un vector) en el registro `$s0`.  
>
> **Ejemplo ASM:**
> ```asm
> la $s0, A
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

## Funciones de entrada/salida (Syscall)

| Código | Descripción | Argumentos | Resultado |
| - | - | - | - |
| 1 | Imprimir entero | $a0 = entero | - |
| 2 | Imprimir flotante | $f12 = flotante | - |
| 3 | Imprimir doble flotante | $f12 = doble flotante | - |
| 4 | Imprimir cadena | $a0 = dirección de la cadena (terminada en el caracter nulo) | - |
| 5 | Leer entero | - | entero guardado en $v0 |
| 6 | Leer flotante | - | flotante guardado en $f0 |
| 7 | Leer doble flotante | - | doble flotante guardado en $f0 |
| 8 | Leer cadena | $a0 = dirección de la cadena<br> $a1 = longitud máxima de la cadena | - |
| 10 | Terminar programa | - | - |
| 11 | Imprimir caracter | $a0 = caracter (entero ASCII del caracter) | - |