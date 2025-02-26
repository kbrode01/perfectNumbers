#Perfect Numbers Program coded in MIPS
#Kevin Brodersen 10/9/2023

.data
msg1:    .asciiz "Enter a value greater than 1: "
msgExit: .asciiz "Exiting program."
newLine: .asciiz "\n"
plus: 	 .asciiz "+"
eq:		 .asciiz "="
prMsg1:  .asciiz "The number "
prMsg2:  .asciiz " is not perfect and prime.\n"
np1:	 .asciiz "The number "
np2: 	 .asciiz " is not perfect.\n"
p1: 	 .asciiz "The number "
p2: 	 .asciiz " is perfect!"
yes:     .asciiz " yes\n"

factors: .space 400 #creating an array that can store up to 100 factors

.text
.globl main
main:   
		la $s2, factors #loading address of factors array into s2
		li $t7, 0 #location / index
		li $t8, 0 #array iterator
		li $s1, 0 #num array values

		li $v0, 4       # Print prompt to output
        la $a0, msg1     
        syscall        
		
		li $v0, 5		#accept user integer input and if less than 2, exit program
		syscall
		move $s3, $v0
				
		li $t1, 2
		blt $s3, $t1, exit
		
		j for
		#for loop to generate new test values -> function, store if return is true
for:	
		beq $s3, $t1, sum
		# s3 contains user num, t1 is our iterator starting at 2 (since 1 is always a factor)
		#send current t1 to function
		jal is_a_factor
		beqz $s0, factor_true #if true add t1 to array
		
		addi $t1, $t1, 1 #if false just iterate
		j for
 
		#function to test whether a value is a factor
is_a_factor:
		div $s3, $t1
		mfhi $s0 #s0 is now any remainder
		
		jr $ra
factor_true:

		sll $t7, $t8, 2 
		addu $t7, $t7, $s2 #memory location + 4*iterator value
		
		
		sb $t1, 0($t7)
		addi $t8, $t8, 1 #iterating array

		addi $s1, $s1, 1 #number of values added to array
		addi $t1, $t1, 1 #go to next value
		j for
sum:		
		#add and print all values in stack
		#add up factors using loop and if == entered print message

		li $v0, 1
		li $a0, 1
		syscall
		
		li $t4, 1
		blt $s1, $t4, prime #when number is prime
		
		li $t5, 1 #current sum
		li $t7, 0 #location / index
		li $t8, 0 #array iterator

		
		j for2
for2:	#for loop to print and add stored factors
		beq $s1, $t8, continued
		
		sll $t7, $t8, 2 
		addu $t7, $t7, $s2 #memory location + 4*iterator value
		
		li $v0, 4
		la $a0, plus
		syscall
		
		li $v0, 1
		lb $a0, 0($t7) #load from array location and print 
		syscall 
		
		lb $t6, 0($t7) # load from array and add to total
		add $t5, $t5, $t6
		#addi $t4, $t4, 1 #moving to next test number
		
		addi $t8, $t8, 1 #iterating array
		
		j for2
		
prime:	#when number is prime
		li $v0, 4
		la $a0, eq
		syscall
		
		li $v0, 1
		li $a0, 1
		syscall
		
		li $v0, 4
		la $a0, newLine
		syscall	
		
		li $v0, 4
		la $a0, prMsg1
		syscall	
		
		li $v0, 1
		move $a0, $s3
		syscall
		
		li $v0, 4
		la $a0, prMsg2
		syscall	

		j main
		
continued:
		li $v0, 4 # equals
		la $a0, eq
		syscall

		li $v0, 1 #sum
		move $a0, $t5
		syscall
		
		li $v0, 4 # newline
		la $a0, newLine
		syscall
		
		
		beq $t5, $s3, perfect #branch if sum = user num
		
		li $v0, 4 #otherwise print not perfect message
		la $a0, np1
		syscall
		
		li $v0, 1
		move $a0, $s3
		syscall
		
		li $v0, 4
		la $a0, np2
		syscall
		
		j reset
perfect: # print perfect message
		li $v0, 4 
		la $a0, p1
		syscall
		
		li $v0, 1
		move $a0, $s3
		syscall
		
		li $v0, 4
		la $a0, p2
		syscall
		
		j reset
reset:	#printing newline and going back to main for another run	
		li $v0, 4
		la $a0, newLine
		syscall
		j main
exit:	#exit message and program exit 
		li $v0, 4
		la $a0, newLine
		syscall
		li $v0, 4 
		la $a0, msgExit 
		syscall
		
        li $v0, 10
		syscall