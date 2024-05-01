########################################################################## 
# Created by: Xu, Mary
# CruzID£º1829011
# 31 May 2021 
# 
# Assignment: Lab 4: Functions and Graphics 
# CSE 12, Computer Systems and Assembly Language # UC Santa Cruz, Sping 2021 
# 
# Description: This program prints ¡®graphic picture for lines and different colot¡¯ to the Bitmap display. # 
# Notes: This program is intended to be run from the MARS IDE. ##########################################################################

# Spring 2021 CSE12 Lab 4 Template
######################################################
# Macros made for you (you will need to use these)
######################################################

# Macro that stores the value in %reg on the stack 
#	and moves the stack pointer.
.macro push(%reg)
	subi $sp $sp 4
	sw %reg 0($sp)
.end_macro 

# Macro takes the value on the top of the stack and 
#	loads it into %reg then moves the stack pointer.
.macro pop(%reg)
	lw %reg 0($sp)
	addi $sp $sp 4	
.end_macro

#################################################
# Macros for you to fill in (you will need these)
#################################################

# Macro that takes as input coordinates in the format
#	(0x00XX00YY) and returns x and y separately.
# args: 
#	%input: register containing 0x00XX00YY
#	%x: register to store 0x000000XX in
#	%y: register to store 0x000000YY in
.macro getCoordinates(%input %x %y)
	# YOUR CODE HERE
	andi %x, %input, 0x00FF0000						#add the x input to this number and set it
	srl %x, %x,16								# set it and get the number 16
	andi %y, %input, 0x000000FF						#add in the y input number
.end_macro

# Macro that takes Coordinates in (%x,%y) where
#	%x = 0x000000XX and %y= 0x000000YY and
#	returns %output = (0x00XX00YY)
# args: 
#	%x: register containing 0x000000XX
#	%y: register containing 0x000000YY
#	%output: register to store 0x00XX00YY in
.macro formatCoordinates(%output %x %y)
	# YOUR CODE HERE
	sll %x, %x, 16								#shif left to let x in 16
	push(%y)
	add %output, %x, %y							#add the output which is x and y
	pop(%y)
.end_macro 

# Macro that converts pixel coordinate to address
# 	  output = origin + 4 * (x + 128 * y)
# 	where origin = 0xFFFF0000 is the memory address
# 	corresponding to the point (0, 0), i.e. the memory
# 	address storing the color of the the top left pixel.
# args: 
#	%x: register containing 0x000000XX
#	%y: register containing 0x000000YY
#	%output: register to store memory address in
.macro getPixelAddress(%output %x %y)
	# YOUR CODE HERE
	mul $t0, %y 128							# set %y to 128 picxel
	add $t0, $t0, %x
	mul $t0, $t0, 4							# make the equation inter () times 4
	add %output, 0xFFFF0000, $t0					# finish adding the equation up
.end_macro


.text
# prevent this file from being run as main
li $v0 10 
syscall

#~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~
#  Subroutines defined below
#~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~
#*****************************************************
# Clear_bitmap: Given a color, will fill the bitmap 
#	display with that color.
# -----------------------------------------------------
# Inputs:
#	$a0 = Color in format (0x00RRGGBB) 
# Outputs:
#	No register outputs
#*****************************************************
clear_bitmap: nop
	# YOUR CODE HERE, only use t registers (and a, v where appropriate)
	push ($t1)
	push ($t2)
	la $t1, 0xFFFF0000				#load word to $t1 for color
	li $t2, 65536					#load it with the number as 128*128*4
	Header:						#give it a name to be more clear
	sw $a0, ($t1)					#store the a0, which is the color format
	addi $t1, $t1, 4				#add immedate the t1 with 4
	addi $t2, $t2, -4				#add immediate the t2 with -4
	bgtz $t2, Header				#the brach is greater than 0 for t2 and hearder
	pop($t2)
	pop($t1)
 	jr $ra

#*****************************************************
# draw_pixel: Given a coordinate in $a0, sets corresponding 
#	value in memory to the color given by $a1
# -----------------------------------------------------
#	Inputs:
#		$a0 = coordinates of pixel in format (0x00XX00YY)
#		$a1 = color of pixel in format (0x00RRGGBB)
#	Outputs:
#		No register outputs
#*****************************************************
draw_pixel: nop
	# YOUR CODE HERE, only use t registers (and a, v where appropriate)
	push($t1)					#push these $t0 so we can use this over and over again so there will be no 
	push($t2)					#miss save or miss understand of t register
	push($t3)
	push($t4)
	getCoordinates($a0, $t2, $t3)
	mul $t4, $t3, 128				#multiply t2 by 128 then save it to t3
	add $t4, $t4, $t2				#add the t3 and t1 to t3
	la $t2, 0xFFFF0000				#load address to t1 for the address of 0xffff0000
	mul $t4, $t4, 4					#multiply t3 with 4 save to t3
	add $t2, $t2, $t4				#add $t1 and t3 save to t1
	sw  $a1, ($t2)					#store word the coordinates a1 to t1
	pop($t4)					#pop it back up
	pop($t3)
	pop($t2)
	pop($t1)
	jr $ra
	
#*****************************************************
# get_pixel:
#  Given a coordinate, returns the color of that pixel	
#-----------------------------------------------------
#	Inputs:
#		$a0 = coordinates of pixel in format (0x00XX00YY)
#	Outputs:
#		Returns pixel color in $v0 in format (0x00RRGGBB)
#*****************************************************
get_pixel: nop
	# YOUR CODE HERE, only use t registers (and a, v where appropriate)
	push($t1)
	push($t2)
	push($t3)
	push($t4)
	getCoordinates($a0, $t2, $t3)
	mul $t4, $t3, 128				#multiply t2 by 128 then save it to t3
	add $t4, $t4, $t2				#add the t3 and t1 to t3
	la $t2, 0xFFFF0000				#load address to t1 for the address of 0xffff0000
	mul $t4, $t4, 4					#multiply t3 with 4 save to t3
	add $t2, $t2, $t4				#add $t1 and t3 save to t1
	lw  $v0, ($t2)					#load word the coordinates a1 to t1
	pop($t4)
	pop($t3)
	pop($t2)
	pop($t1)
	jr $ra

#*****************************************************
# draw_horizontal_line: Draws a horizontal line
# ----------------------------------------------------
# Inputs:
#	$a0 = y-coordinate in format (0x000000YY)
#	$a1 = color in format (0x00RRGGBB) 
# Outputs:
#	No register outputs
#*****************************************************
draw_horizontal_line: nop
	# YOUR CODE HERE, only use t registers (and a, v where appropriate)
	push ($t1)
	push ($t2)
	push ($t3)
	li $a0, 512					#load the y-coordinates with 512 because there are 128 pixel and each pixel
							#is 4 bit equal
	mul $t1, $a0, 32				#there are total four 32 pixel in 128 pixel excatly, so multiply the y-coordinates
							#with the 32 found excatly in 128 pixel and save it in ti
	addi $t2, $t1,0xFFFF0000			#make sure each time the y-coordinates will starts at the origin point
	li $t3, 512					#load it with the number as 128*4 because there are 128 pixel and 4 bit
	horizontal:
	sw $a1, ($t2)					#store the a0, which is the color format
	addi $t2, $t2, 4				#add immedate the t1 with 4, it is four because 128 * 4 so each time add four
	addi $t3, $t3, -4				#add immediate the t2 with -4, same as here, each time minues four
	bgtz $t3, horizontal				#the brach is greater than 0 for t2 and hearder
	pop ($t3)
	pop($t2)
	pop($t1)
 	jr $ra

#*****************************************************
# draw_vertical_line: Draws a vertical line
# ----------------------------------------------------
# Inputs:
#	$a0 = x-coordinate in format (0x000000XX)
#	$a1 = color in format (0x00RRGGBB) 
# Outputs:
#	No register outputs
#*****************************************************
draw_vertical_line: nop
	# YOUR CODE HERE, only use t registers (and a, v where appropriate)
	push ($t1)
	push ($t2)
	push ($t3)
	mul $t1, $a0, 4
	addi $t1, $t1,0xFFFF0000
	li $t2, 512					#load it with the number as 1284
	vertical:
	sw $a1, ($t1)					# the same loop give it a fit name and run over again
	addi $t1, $t1, 512				
	addi $t2, $t2, -4				
	bgtz $t2, vertical				
	pop ($t3)
	pop($t2)
	pop($t1)
 	jr $ra


#*****************************************************
# draw_crosshair: Draws a horizontal and a vertical 
#	line of given color which intersect at given (x, y).
#	The pixel at (x, y) should be the same color before 
#	and after running this function.
# -----------------------------------------------------
# Inputs:
#	$a0 = (x, y) coords of intersection in format (0x00XX00YY)
#	$a1 = color in format (0x00RRGGBB) 
# Outputs:
#	No register outputs
#*****************************************************
draw_crosshair: nop
	push($ra)
	
	# HINT: Store the pixel color at $a0 before drawing the horizontal and 
	# vertical lines, then afterwards, restore the color of the pixel at $a0 to 
	# give the appearance of the center being transparent.
	
	# Note: Remember to use push and pop in this function to save your t-registers
	# before calling any of the above subroutines.  Otherwise your t-registers 
	# may be overwritten.  
	
	# YOUR CODE HERE, only use t0-t7 registers (and a, v where appropriate)
	push ($t1)
	push ($t2)
	push ($t3)
	push ($t4)
	push ($t5)
	push ($t6)
	getCoordinates($a0, $t4, $t1)
	la $t7, ($v0)
	jal get_pixel
	la $t7, ($a1)
	li $a0, 512					
	mul $t1, $a0, 64				
	addi $t2, $t1,0xFFFF0000			
	li $t3, 512					
	horizontalc:
	sw $a1, ($t2)					
	addi $t2, $t2, 4				
	addi $t3, $t3, -4				
	bgtz $t3, horizontalc				
	move $a0, $t4
	jal draw_vertical_line
	la $t7, ($v0)
	jal draw_pixel
	pop($t6)
	pop($t5)
	pop($t4)
	pop($t3)
	pop($t2)
	pop($t1)

	# HINT: at this point, $ra has changed (and you're likely stuck in an infinite loop). 
	# Add a pop before the below jump return (and push somewhere above) to fix this.
	jr $ra
