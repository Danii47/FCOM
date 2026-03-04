.data
    info: .ascii	"Taller ensamblador MIPS\n"
    	  .ascii	"11/03/2026\n"
    	  .ascii	"12:00-13:30\n"
    	  .ascii	"Laboratorio General\n"
    	  .asciiz	"SUGUS\n"

.text
.globl main

main:
    li $v0, 4          
    la $a0, info
    syscall

    li $v0, 10
    syscall