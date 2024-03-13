
# HOJA DE REFERENCIA MIPS


| Instrucción | Parámetros | Descripción | Ejemplo |
| - | - | - | - |
| la | rd, Etiqueta | Carga la dirección representada por Etiqueta en el registro rd | la $s0, A |
| add | rd, rs, rt | Suma con detección de desbordamiento: rd <- rs + rt | add $s2, $s1, $s0 |
| addi | rd, rs, inm | Suma inmediata (con signo extendido): rd <- rs + inm | addi $s2, $s1, 5 |
| sub | rd, rs, rt | Resta con detección de desbordamiento: rd <- rs - rt | sub $s2, $s1, $s0 |
| lw | rd, d(rs) | Lee el contenido de rs + d (desplazamiento) y lo carga en rd | lw $t1, 0($t0) |
| sll | rd, rt, d | Desplaza a la izquierda el contenido de rt d veces y lo almacena en rd | sll $t2, $t1, 2 |
| slt | rd, rs, rt | Establece rd en 1 si rs < rt, de lo contrario, establece rd en 0 | slt $t2, $t1, $t0 |
| slti | rd, rs, inm | Establece rd en 1 si rs < inm (con signo extendido), de lo contrario, establece rd en 0 | slti $t2, $t1, 5 |

----

> [!TIP]
> La instrucción `add` suma los valores de los registros `$s1` y `$s0` y almacena el resultado en el registro `$s2`.  
> 
> **Ejemplo ASM:**
> ```asm
> add $s2, $s1, $s0
> ```

----

> [!TIP]
> La instrucción `addi` suma el valor inmediato `x` (Ej: 10) al valor del registro `$s1` y almacena el resultado en el registro `$s2`.  
> Que sea con signo extenido significa que si el valor inmediato es negativo, se extiende el bit de signo para que el valor sea negativo. 
>  
> **Ejemplo ASM:**
> ```asm
> addi $s2, $s1, 10
> ```

----

> [!TIP]
> La instrucción `sub` resta los valores de los registros `$s1` y `$s0` y almacena el resultado en el registro `$s2`. 
>  
> **Ejemplo ASM:**
> ```asm
> sub $s2, $s1, $s0
> ```

----

> [!TIP]
> La instrucción `lw` carga la palabra en la dirección de memoria contenida en el registro `$t1` en el registro `$t2`. El desplazamiento es `0`, por lo que se carga la palabra exactamente en la dirección contenida en `$t1`.  
> *Puede ser útil para cargar un valor de un vector en un registro.*
> 
> **Ejemplo ASM:**
> ```asm
> lw $t1, 0($t0)
> ```

----

> [!TIP]
> La instrucción `sll` desplaza el contenido del registro `$t1` un `d` posiciones a la izquierda y almacena el resultado en el registro `$t2`.
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
> La instrucción `slt` establece el valor del registro `$t2` en 1 si el valor del registro `$t1` es menor que el valor del registro `$t0`, de lo contrario, establece el valor del registro `$t2` en 0. 
>  
> **En Python:**
> ```py
> t2 = 1 if t1 < t0 else 0
> ```
> **En JavaScrip:**
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
> La instrucción `slti` establece el valor del registro `$t2` en 1 si el valor del registro `$t1` es menor que el valor inmediato `x`, de lo contrario, establece el valor del registro `$t2` en 0.  
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
> La instrucción `la` carga la dirección de memoria representada por la etiqueta `A` (Ej: un vector) en el registro `$s0`.  
>
> **Ejemplo ASM:**
> ```asm
> la $s0, A
> ```
