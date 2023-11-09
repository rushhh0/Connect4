# Project By: Kamal, Rushi, Shivani, Gaurav

.include "macroC4.asm"

.data

# Our theme was inspired by a computer terminal which is shown with the white and green tokens and black and gray board
ColorTable:	
 .word 0x808080 # Gray   	Board Color
 .word 0x00FF00 # Green  	Player Token Color
 .word 0xFFFFFF # White  	Computer Token Color
 .word 0x000000 # Black  	Background Color


# Each token is 8x8 pixels. To be able to print a token we need the X - Offset, and the length (1 is minimum and 8 is maximum). 
# For our token we start off at 0 and then give a length of 8 at each X-offset. 
token: 			.word 0, 8, 0, 8, 0, 8, 0, 8, 0, 8, 0, 8, 0, 8, 0, 8		# Array that will store the X-Offset and length of the token	

boardArray: 		.byte 0:42		# Array that will represent the board

# All the messages that will be used throughout the program
welcomePrompt: 		.asciiz "Welcome to Connect 4!\nThis is a MIPS version of the classic 2 player board game Connect 4.\nThe game will begin with Player 1's turn.\nEnter 1-7 to choose which column to place the game piece in.\nOnce Player 1 goes, Player 2 may then take their turn.\nThe game will automatically alternate user turns so be patient and once you see the game piece placed on the Bitmap it is time for the other player to take their turn!\n\nHave fun!\n\n"
usersTurn: 		.asciiz "\nYour turn: "
userWinPrompt: 		.asciiz "You Won!\n"
computerWinPrompt: 	.asciiz "Computer Won!\n"
validMove: 		.asciiz "Please enter a number between from range 1 to 7\n"
invalidMove: 		.asciiz "The column you have chosen is full. Select a different column\n"
tiePrompt: 		.asciiz "Game Tied!\n"


.text

jal DrawGameBoard				# Drawing gameboard

# Print the welcome message
printString("Welcome to Connect 4!\nThis is a MIPS version of the classic 2 player board game Connect 4.\nThe game will begin with Player 1's turn.\nEnter 1-7 to choose which column to place the game piece in.\nOnce Player 1 goes, Player 2 may then take their turn.\nThe game will automatically alternate user turns so be patient and once you see the game piece placed on the Bitmap it is time for the other player to take their turn!\n\nHave fun!\n\n")


################################  Begin Main ################################ 
main:

# User Logic
HumanPlayer:

# Asking user for input
printString("\nYour turn: ")

# Getting input from user
li $v0, 5
syscall

# Store user input into array and check if valid
li $a0, 1
jal StoreInput

# Draw user's token
li $a0, 1
jal DrawPlayerToken

jal WinnerCheck						# Check if the user won


# Computer Logic

# Generate a random number between 0 - 6
addi $a1, $zero, 7
addi $v0, $zero, 42
syscall

# Add 1 to $a0 to make the range 1 - 7
addi $a0, $a0, 1
move $v0, $a0

# Adding user input into array
li $a0, 2
jal StoreInput

# Draw computer's token
li $a0, 2
jal DrawPlayerToken

jal WinnerCheck						# Check if the computer won

j main							# Go back to the beginning

################################  Begin All Drawing Procedures ################################ 

#Procedure: DrawPlayerToken
#Input: $a0 - Player Number
#Input: $v0 - Slot Number (0-41)
#Will format player data then DrawPiece
DrawPlayerToken:

	# Making space	
	addiu $sp, $sp, -12
	sw $ra, ($sp)
	sw $a0, 4($sp)
	sw $v0, 8($sp)
	
	# Move token number
	move $a2, $a0
	
	# Calculating address
	li $t0, 7
	div $v0, $t0
	mflo $t0					
	mfhi $t1					

	# Address for Y coordinate
	li $t2, 50
	mul $t0, $t0, 9
	mflo $t0
	sub $t0, $t2, $t0 				
	
	# Address for X coordinate
	mul $t1, $t1, 9
	addi $t1, $t1, 1
	
	# Moving addresses 
	move $a0, $t1
	move $a1, $t0
	
	# Drawing piece
	jal DrawPiece
	
	lw $v0, 8($sp)
	lw $a0, 4($sp)
	lw $ra, ($sp)
	addiu $sp, $sp, 4
	jr $ra

# Will draw the board
DrawGameBoard:
	addiu $sp, $sp, -4
	sw $ra, ($sp)
	
	#Black Background
	li $a0, 0
	li $a1, 0
	li $a2, 3					# Black
	li $a3, 64
	jal DrawGrid
	
	# Drawing top bar
	li $a0, 0					# Start at X = 0
	li $a1, 0					# Start at Y = 0
	li $a2, 0					# Gray
	li $a3, 64					# 8x8 pixels
	jal DrawHorizontal
	li $a1, 1
	jal DrawHorizontal
	li $a1, 2	
	jal DrawHorizontal
	li $a1, 3	
	jal DrawHorizontal
	li $a1, 4	
	jal DrawHorizontal
	
	# Drawing bottom border
	li $a0, 0					# Start at X = 0
	li $a1, 58					# Start ar Y = 57
	li $a2, 0					# Gray
	li $a3, 64					# 64 pixels wide
	jal DrawHorizontal
	li $a1, 59
	jal DrawHorizontal
	li $a1, 60	
	jal DrawHorizontal
	li $a1, 61	
	jal DrawHorizontal
	li $a1, 62	
	jal DrawHorizontal
	li $a1, 63	
	jal DrawHorizontal


	# Drawing vertical lines
	li $a0, 0					# Start at X = 0
	li $a1, 0					# Start at Y = 0
	li $a2, 0					# Gray
	li $a3, 64					# 64 pixels wide
	jal DrawVertical	
	li $a0, 9					# (X = 9)
	jal DrawVertical
	li $a0, 18					# (X = 18)
	jal DrawVertical
	li $a0, 27					# (X = 27)
	jal DrawVertical
	li $a0, 36					# (X = 36)
	jal DrawVertical
	li $a0, 45					#(X = 45)
	jal DrawVertical
	li $a0, 54					# (X = 54)
	jal DrawVertical
	li $a0, 63					# (X = 63)
	jal DrawVertical

	# Drawing horizontal lines
	li $a0, 0					# Start at X = 0
	li $a1, 13					# Start ar Y = 13
	li $a2, 0					# Gray
	li $a3, 64					# 64 pixels wide
	jal DrawHorizontal
	li $a1, 22
	jal DrawHorizontal
	li $a1, 31	
	jal DrawHorizontal
	li $a1, 40	
	jal DrawHorizontal
	li $a1, 49	
	jal DrawHorizontal

	lw $ra, ($sp)
	addiu $sp, $sp, 4
	jr $ra


# Draw an individual piece
DrawPiece:
	
	addiu $sp, $sp, -28 				# Make room for 7 words
	sw $ra, 20($sp)
	sw $s0, 16($sp)
	sw $a0, 12($sp)
	sw $a2, 8($sp)
	li $s2, 0					# Tracker
	
CircleLoop:
	la $t1, token
	addi $t2, $s2, 0				# Copying counter
	mul $t2, $t2, 8					
	add $t2, $t1, $t2				# Getting x offset
	lw $t3, ($t2)					
	add $a0, $a0, $t3				# Add x offset to current x value
	
	addi $t2, $t2, 4				# move to horizontal line length in array
	lw $a3, ($t2)					
	sw $a1, 4($sp)					
	sw $a3, 0($sp)					
	sw $s2, 24($sp)					# Save traceker
	jal DrawHorizontal
	
	# Reset registers
	lw $a3, 0($sp)
	lw $a1, 4($sp)
	lw $a2, 8($sp)
	lw $a0, 12($sp)
	lw $s2, 24($sp)
	addi $a1, $a1, 1				# increase y
	addi $s2, $s2, 1				# increment tracker
	bne $s2, 8, CircleLoop				
	
	
	# reset registers
	lw $ra, 20($sp)
	lw $s0, 16($sp)
	addiu $sp, $sp, 28				#Reset $sp
	jr $ra
	

# Draw the grid
DrawGrid:
	addiu $sp, $sp, -24 				# make space for 6 words

	sw $ra, 20($sp)
	sw $s0, 16($sp)
	sw $a0, 12($sp)
	sw $a2, 8($sp)
	move $s0, $a3					

# Loop to build boxes	
BoxLoop:
	sw $a1, 4($sp)					# Save $a1
	sw $a3, 0($sp)					# Save $a3
	jal DrawHorizontal
	
	# Reset registers
	lw $a3, 0($sp)
	lw $a1, 4($sp)
	lw $a2, 8($sp)
	lw $a0, 12($sp)
	addi $a1, $a1, 1				# increase y
	addi $s0, $s0, -1				# decrease length/width
	bne $zero, $s0, BoxLoop				
	
	# reset registers
	lw $ra, 20($sp)
	lw $s0, 16($sp)
	addiu $sp, $sp, 24				# reset sp
	jr $ra
	

# Draw horizontal stuff
DrawHorizontal:
	addiu $sp, $sp, -28
	# reset registers
	sw $ra, 16($sp)
	sw $a1, 12($sp)
	sw $a2, 8($sp)
	sw $a0, 20($sp)
	sw $a3, 24($sp)
	
HorizontalLoop:
	
	sw $a0, 4($sp)
	sw $a3, 0($sp)
	jal DrawDot
	
	# reset registers
	lw $a0, 4($sp)
	lw $a1, 12($sp)
	lw $a2, 8($sp)
	lw $a3, 0($sp)	
	addi $a3, $a3, -1				# decrease width
	addi $a0, $a0, 1				# increment x
	bnez $a3, HorizontalLoop				
	lw $ra, 16($sp)				# reset ra
	lw $a0, 20($sp)
	lw $a3, 24($sp)
	addiu $sp, $sp, 28				#reset sp
	jr $ra
	
# Draw vertical stuff
DrawVertical:
	addiu $sp, $sp, -28
	sw $ra, 16($sp)
	sw $a1, 12($sp)
	sw $a2, 8($sp)
	sw $a0, 20($sp)
	sw $a3, 24($sp)
	
VerticalLoop:
	
	sw $a1, 4($sp)
	sw $a3, 0($sp)
	jal DrawDot
	
	# reset registers
	lw $a1, 4($sp)
	lw $a0, 20($sp)
	lw $a2, 8($sp)
	lw $a3, 0($sp)	
	addi $a3, $a3, -1				# Decrement the width
	addi $a1, $a1, 1				# Increase Y value
	bnez $a3, VerticalLoop					
	lw $ra, 16($sp)					# reset ra
	lw $a1, 12($sp)
	lw $a3, 24($sp)
	addiu $sp, $sp, 28				# reset sp
	jr $ra
	

# Draws dot based on hex color 
DrawDot:
	addiu $sp, $sp, -8
	#Save $ra, $a2
	sw $ra, 4($sp)
	sw $a2, 0($sp)
	jal CalculateAddress				# Calculate memory address to write to
	lw $a2, 0($sp)					# Load $a2
	sw $v0, 0($sp)					# Save $v0
	jal GetColor					# Retrieve Hex value of color
	lw $v0, 0($sp)					# Restore $v0
	sw $v1, ($v0)					# Write the color value to the proper memory address
	lw $ra, 4($sp)					# reset $ra
	addiu $sp, $sp, 8				# Reset $sp
	jr $ra


#Procedure: CalculateAddress
#Input - $a0 = X
#Input - $a1 = Y
#Output - $v0 = actual memory address to draw dot
CalculateAddress:
	sll $t0, $a0, 2					#Multiply X by 4
	sll $t1, $a1, 8					#Multiply Y by 64*4 (512/8= 64 * 4 words)
	add $t2, $t0, $t1				#Add 
	addi $v0, $t2, 0x10040000			#Add base (heap value)
	jr $ra

#Procedure: GetColor
#Input - $a2 = Color Value (0-5)
#Output - $v1 = Hex color value
#Returns the hex value of requested color
GetColor:
	la $t0, ColorTable				#Load color table
	sll $a2, $a2, 2					#Shift left by 2 (x4)
	add $a2, $a2, $t0				#Add base
	lw $v1, ($a2)					#Load color value to $v1
	jr $ra

################################  End All Drawing Procedures ################################ 


#Procedure: StoreInput
#Input: User entered value - $v0
#Input: Player Number (1 or 2) - $a0
#Output: Box Number ($v0)
#Will determine which exact array location to place user input and store it into array
StoreInput:
#the user input in converted into Array; the nextCheck Loop is incremented 
	addiu $v0, $v0, -8				
	bltu $v0, -7, OOBError
	bgtu $v0, -1, OOBError
	
	#Searches for the next open row
	nextCheck:
	addiu $v0, $v0, 7				#row is incremented
	bgtu $v0, 41, ColumnFull			#goes to error if the  column is fill
	lb $t1, boardArray($v0)			#the byte that the user has chosen is loaded from boardArray
	bnez $t1, nextCheck				#If loaded byte is full, then try next row up
	sb $a0, boardArray($v0)			#player number is placed into boardArray where the player's token last location was
	
	jr $ra						#procedure was successful 
	#Errors
	#out of bounds
	OOBError:
	move $t0, $a0
	printString("Please enter a number between from range 1 to 7\n")
	move $a0, $t0
	j returnToPlayer
	
	#full column
	ColumnFull:
	move $t0, $a0
	printString("The column you have chosen is full. Select a different column\n")
	move $a0, $t0
	
	returnToPlayer:
	beq $a0, 1, HumanPlayer
	#beq $a0, 2, ComputerPlayer
	
################################  Begin WinnerCheck ################################ 
#Check winner, after the move is made by the player
WinnerCheck:    	
     	#Must check FOUR different directions a win can happen:
     	#1. Horizontal Line
     	#2. Vertical Line
     	#3. Diagonal Left to Right
     	#4. Diagonal Right to left
    	
     	#5. Check for Full Board (Tie)

     	addiu $sp, $sp, -4
     	sw $ra, ($sp)
     	
        li $t8, 7					#Constant 7 used for modulo division for leftmost and rightmost checking
          	 	
    	#-----------------Check horizontal-----------------#
     	#From start, go LEFT as far possible
     	li $t9, 1					#Counter for the win (4 in a row)
	move $t2, $v0					#Copy the content into $t2 for manipulation when searching LEFT
	move $t4, $v0					#Copy the content into $t4 for manipulation when searching RIGHT
        checkLeft:
     	la $t0, boardArray($t2)				#Load our current Token address
     	
        #If we are at the leftmost slot, skip to check right
     	div $t2, $t8
     	mfhi $t3					
     	beqz $t3, checkRight				     	
     	#Else look at slot to our left
     	lb $t1, -1($t0)					
     	bne $t1, $a0, checkRight			
#If value is not equal to player number, then proceed to check right
     	addiu $t9, $t9, 1				
#Else value is player number, increment counter and check next left
     	addiu $t2, $t2, -1
	bgt $t9, 3, PlayerWinnerCheck			#If player got 4 in a row declare them winner
     	j checkLeft
     	
     	#Move towards right from start position
	checkRight:
	la $t0, boardArray($t4)
	
	#End horizontal checking if we reach on the right-most side of the grid
	div $t4, $t8
	mfhi $t3
	beq $t3, 6, endHorizontalChecking		#If modulo result = 6 then we know we are in rightmost slot
	
	#Else look at slot to our right
	lb $t1, 1($t0)					#Right of current location
	bne $t1, $a0, endHorizontalChecking		#If value is not player number, end checking
	addiu $t9, $t9, 1					
addiu $t4, $t4, 1				
	bgt $t9, 3, PlayerWinnerCheck			#If player got 4 in a row declare them winner
	j checkRight
	
	endHorizontalChecking:
	#-----------------End Horizontal Check-----------------#
	
     	
     	#-----------------Check vertical-----------------#
     	#From start, go UP as far possible
     	li $t9, 1					#Counter for the win (4 in a row)

	move $t2, $v0					#Copy the content into $t2 for manipulation when searching TOP
	move $t4, $v0					#Copy the content into $t4 for manipulation when searching BOTTOM
        checkTop:
     	la $t0, boardArray($t2)				#Load our current Token address
     	
        #If we are at the top row, skip to checkBottom
     	bgtu $t2, 34, checkBottom			#If our offset is greater than 34 that means we are on the top row
     	
     	#Else look at slot above us
     	lb $t1, 7($t0)					#Left of current location
     	bne $t1, $a0, checkBottom			#If value is not equal to player number, then proceed to check down
     	addiu $t9, $t9, 1				#Else value is player number, increment counter and check next row up
     	addiu $t2, $t2, 7
	bgt $t9, 3, PlayerWinnerCheck			#If player got 4 in a row declare them winner
     	j checkTop
     	
     	#From start, go down as far possible
	checkBottom:
	la $t0, boardArray($t4)
	
	#If we are at bottom row, end vertical checking
	bltu $t4, 7, endVerticalChecking
	
	#Else look at slot below us
	lb $t1, -7($t0)					#Below current location
	bne $t1, $a0, endVerticalChecking		#If value is not player number, end checking
	addiu $t9, $t9, 1				#Else increment counter
	addiu $t4, $t4, -7				
	bgt $t9, 3, PlayerWinnerCheck			#If player got 4 in a row declare them winner
	j checkBottom
	
	endVerticalChecking:  
     	#-----------------End Vertical Check-----------------#
     	
     	
     	
     	
     	#-----------------Check forward-slash diagonal-----------------#
	#From start, go UP-RIGHT (UR) as far possible
     	li $t9, 1					#Counter for the win (4 in a row)
	move $t2, $v0					#Copy the content into $t2 for manipulation when searching TOPRIGHT
	move $t4, $v0					#Copy the content into $t4 for manipulation when searching BOTTOMLEFT
        checkTopRight:
     	la $t0, boardArray($t2)				#Load our current Token address
     	
        #If we are at the top row OR we are at the rightmost column, then skip to down-left
     	bgtu $t2, 34, checkBottomLeft			#If our offset is greater than 34 that means we are on the top row
	div $t2, $t8
	mfhi $t3
	beq $t3, 6, checkBottomLeft			#If modulo result = 6 then we know we are in rightmost slot
     	
     	#Else look at slot above us and over to the right 
     	lb $t1, 8($t0)					#TOPRIGHT of current location
     	bne $t1, $a0, checkBottomLeft			#If value is not equal to player number, then proceed to check right
     	addiu $t9, $t9, 1				#Else value is player number, increment counter and check next value in pattern
     	addiu $t2, $t2, 8
	bgt $t9, 3, PlayerWinnerCheck			#If player got 4 in a row declare them winner
     	j checkTopRight
     	
     	#From start, go BOTTOM-LEFT (BL) as far possible
	checkBottomLeft:
	la $t0, boardArray($t4)
	
	#If we are at bottom row OR leftmost column, then end ForwardSlashDiagonal checking
	bltu $t4, 7, endForwardSlashDiagonal		#Bottom row test
	div $t4, $t8
	mfhi $t3
	beq $t3, 0, endForwardSlashDiagonal		#Leftmost column test
	
	#Else look at slot below us and over to the left one
	lb $t1, -8($t0)					#BOTTOMLEFT of current location
	bne $t1, $a0, endForwardSlashDiagonal		#If value is not player number, end checking
	addiu $t9, $t9, 1				#Else increment counter
	addiu $t4, $t4, -8				
	bgt $t9, 3, PlayerWinnerCheck			#If player got 4 in a row declare them winner
	j checkBottomLeft
	
	endForwardSlashDiagonal:  
     	#-----------------End Forward-Slash Diagonal Check-----------------#
     	
     	
     	
     	
     	#-----------------Check backward-slash diagonal-----------------#
	#From start, go TOP-LEFT (TL) as far possible
     	li $t9, 1					#Counter for the win (4 in a row)
	move $t2, $v0					#Copy the content into $t2 for manipulation when searching TOPLEFT
	move $t4, $v0					#Copy the content into $t4 for manipulation when searching BOTTOMRIGHT
        checkTopLeft:
     	la $t0, boardArray($t2)				#Load our current Token address
     	
        #If we are at the top row OR we are at the leftmost column, then skip to down-right
     	bgtu $t2, 34, checkBottomRight			#Top row test
	div $t2, $t8
	mfhi $t3
	beq $t3, 0, checkBottomRight			#Left-most column test
     	
     	#Else look at slot above us and over to the left 
     	lb $t1, 6($t0)					#Top and Left of current position
     	bne $t1, $a0, checkBottomRight			#If value is not equal to player number, then proceed to check right
     	addiu $t9, $t9, 1				#Else value is player number, increment counter and check next value in pattern
     	addiu $t2, $t2, 6
	bgt $t9, 3, PlayerWinnerCheck			#If player got 4 in a row declare them winner
     	j checkTopLeft
     	
     	#From start, go BOTTOM-RIGHT (BR) as far possible
	checkBottomRight:
	la $t0, boardArray($t4)
	
	#If we are at bottom row OR rightmost column, then endBackwardSlashDiagonal checking
	bltu $t4, 7, endBackwardSlashDiagonal		#Bottom row test
	div $t4, $t8
	mfhi $t3
	beq $t3, 6, endBackwardSlashDiagonal		#Right-most column test
	
	#Else look at slot below us and over to the right one
	lb $t1, -6($t0)					#BR of current location
	bne $t1, $a0, endBackwardSlashDiagonal		#If value is not player number, end checking
	addiu $t9, $t9, 1				#Else increment counter
	addiu $t4, $t4, -6				
	bgt $t9, 3, PlayerWinnerCheck			#If player got 4 in a row declare them winner
	j checkBottomRight
	
	endBackwardSlashDiagonal:     	
     	#-----------------End Backward-Slash Diagonal Check-----------------#
     	
     	#-----------------Start Full Board Check-----------------#
     	li $t9, 35					#Load the offset for the top row of the gameboard
     	la $t0, boardArray($t9)
     	
     	li $t2, 0					#Counter for # of player Tokens in top row
    	checkUp:
    	lb $t1, ($t0)
    	beqz $t1, endTie				#Check if any position is empty
    	addi $t0, $t0, 1
    	add $t2, $t2, 1	
    	beq $t2, 7, tiePrompt				#Check if top row is completely filled
    	j checkUp	
    
    	endTie:
     	#-----------------End Full Board Check-----------------#
	
	lw $ra, ($sp)
	addiu $sp, $sp, 4	
	jr $ra						#Jump back to the game after all checks are done
	

################################  End WinnerCheck ################################ 

#This will only happen when the whole grid is filled and no player won
#It will also exit the code
GameTie:
	printString("Game Tied!\n")
	exit()


#It will iterate when a player wins the game
#It will prompt the winner message and exit the program
PlayerWinnerCheck:
	beq $a0, 1 userWinner				#If user player won, jump to second instruction set
	
	#Computer player Won
	printString("Computer Won!\n")
	exit()
	
	#User (You) Won
	userWinner:
	printString("You Won!\n")
	exit()

