# A function that prints a string
.macro printString(%s)
	.data
str: .asciiz %s
	.text
	li $v0, 4
	la $a0, str
	syscall
.end_macro

# A function that ends the program
.macro exit()
	.data
	.text
	li $v0, 10
	syscall
.end_macro
