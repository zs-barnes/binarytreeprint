
#The root node is at label "root".
#Each node stores the address of its left node, then the address of
#its right node, and then the node's value.
#Empty trees are represented by address 0.

#This tree should print as follows: (view sideways so 10 is at the top)
#    22
#      19
#  17
#10
#    7
#  4
#    2

.data
.align 2
root:	.word node1, node3, 10 
node1:	.word node5, node2, 4
node2:	.word 0, 0, 7
node3:	.word 0, node6, 17
node4:	.word 0, 0, 19
node5:	.word 0, 0, 2
node6:	.word node4, 0, 22


.text

#main function:
	la	$a0, root		#call the print function
	addi	$a1, $zero, 0		#$a1 is the depth
	jal 	print

	addi	$v0, $zero, 10		#exit the program
	syscall
	
	print:
	#store return address, root, and depth to stack
	addi	$sp, $sp, -16
	sw 	$ra, ($sp)
	sw 	$s0, 4($sp)
	sw	$s1, 8($sp)
	
	#if (root == null)
	#return
	beqz 	$a0, return
	
	#recursive call for print(root.right, depth +1)
	addi	$s0, $a0, 0
	addi	$s1, $a1, 0	
	lw 	$a0, 4($a0)
	addi 	$a1, $a1, 1
	jal 	print
	
	#for(int i=0; i<depth; i++)
	addi 	$t0, $zero, 0
	
loop:	bge 	$t0, $s1, printval
	addi 	$a0, $zero, 32		#System.out.print(" "); //2 spaces
	addi 	$v0, $zero, 11
	syscall				#print 1 space
	addi 	$a0, $zero, 32	
	addi 	$v0, $zero, 11
	syscall				#print  2 spaces
	addi 	$t0, $t0, 1
	b loop

printval:
	lw	$a0, ($s0)
	lw	$a0, 8($s0)
	addi	$v0, $zero, 1
	syscall				#System.out.println(root.value);
	addi	$a0, $zero, 10		#print newline
	addi	$v0, $zero, 11
	syscall
	
	#recursive call for print(root.left, depth +1)
	lw 	$a0, ($s0)
	addi 	$a1, $s1, 1
	jal 	print
	
	#restore return address and local variable memory
return: lw	$ra, ($sp)
	lw	$s0, 4($sp)
	lw	$s1, 8($sp)
	addi	$sp, $sp, 16
	jr 	$ra