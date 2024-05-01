.data

msg: .asciiz "Enter the height of the pattern (must be greater than 0):	"		# store the sentence in the data segment and the add it in the terminator 
space: .asciiz "	"								# store the space in the pyramind
newline: .asciiz "\n"									# to start a new line use the the store statement
star: .asciiz "*"
errorMsg: .asciiz "Invalid Entry!"

.text

main:
	# user input
	li $v0, 4
	la $a0, msg
	syscall
	li $v0, 5
	syscall
	
	move $s0, $v0									# height of pyramid
	move $s1, $v0
	addi $s1, $s1, -1                         				   	# number of tab required before each line

	li $v0, 4
	la $a0, newline
	syscall
	
	li $t0, 1
	
	ble $s0, 0, terminate
	
	print_row:
		bgt $t0, $s0, exit
		beq $t0, 1, print_firstrow
		
											# print spaces
		move $a1, $s0
		sub $a1, $a1, $t0
		mul $a1,$a1,1		
		jal print_spaces
		addi $s1, $s1, -1

		
		li $v0, 1
		addi $s7, $t0, -1
		mul $s7, $s7, 2
		move $a0, $s7
		syscall
		
		li $v0, 4
		la $a0, space
		syscall
		
											# print stars
		
		addi $a1,$t0,-1
		mul $a1, $a1, 2
		addi $a1,$a1,-1
		jal print_stars
		addi $t0, $t0, 1
		
		li $v0, 1
		addi $s7, $s7, 1
		move $a0, $s7
		syscall
		
		li $v0, 4
		la $a0, newline
		syscall
		j print_row

	exit: li $v0, 10
	syscall	
	
	
	print_firstrow:
	
	move $s6, $t0
	jal print_firstspace
	addi $s7,$s7,-1
	li $v0, 1
	la $a0, 1
	syscall
	li $v0, 4
	la $a0, newline
	syscall
	addi $t0, $t0, 1
	j print_row
	
print_stars:
	# print $a1 number of stars
	addi $sp, $sp, -12
	sw $ra, ($sp)
	sw $v0, 4($sp)
	sw $a0, 8($sp)
	li $v0, 4
	star_loop:
		beq $a1, $zero, return_stars
		la $a0, star
		syscall
		la $a0, space
		syscall
		addi $a1, $a1, -1
		j star_loop
	return_stars: lw $ra, ($sp)								#la $a0, newline
	#syscall
	lw $ra, ($sp)
	lw $v0, 4($sp)
	lw $a0, 8($sp)
	addi $sp, $sp, 12
	jr $ra

print_spaces:
	# print $a1 number of spaces
	addi $sp, $sp, -12
	sw $ra, ($sp)
	sw $v0, 4($sp)
	sw $a0, 8($sp)
	li $v0, 4
	la $a0, space
	print_one_more:
		beq $a1, $zero, return_spaces
		syscall
		addi $a1, $a1, -1
		j print_one_more
	return_spaces: lw $ra, ($sp)
	lw $v0, 4($sp)
	lw $a0, 8($sp)
	addi $sp, $sp, 12
	jr $ra


print_firstspace:
	# print $s6 number of spaces
	addi $sp, $sp, -12
	sw $ra, ($sp)
	sw $v0, 4($sp)
	sw $a0, 8($sp)
	move $s6, $s0
	mul $s6, $s6, 1
	addi $s6, $s6, -1									#the input $s6 minus one 
	li $v0, 4
	la $a0, space
	print_more:
		beq $s6, $zero, return_sp
		syscall
		addi $s6, $s6, -1
		j print_more
	return_sp: la $a0, space                                   				#lw $ra, ($sp)
	lw $v0, 4($sp)
	lw $a0, 8($sp)
	addi $sp, $sp, 12
	jr $ra

terminate:
	li $v0, 4
	la $a0, errorMsg
	syscall
