
	.data
	
	.text
	
main:

	addi sp, sp, -44

	li a0, 2		# a0 = 2
	li a1, 16		# a1 = 16
	
	add s7, a0, a1		
	sw s7, 0(sp)		#sp(0) = 16 + 2 = 18
	
	sub s7, a1, a0
	sw s7, 4(sp)		#sp(1) = 16 - 2 = 14
	
	addi s7, a0, 6
	sw s7, 8(sp)		#sp(2) = 2 + 6 = 8
	
	li a0, 0x00000033	#a0 = 0x00000033
	li a1, 0x00000055	#a1 = 0x00000055
	
	and s7, a0, a1		
	sw s7, 12(sp)		
	
	andi s7, a0, 0x00000066
	sw, s7, 16(sp)
	
	or s7, a0, a1
	sw s7, 20(sp)
	
	ori s7, a0, 0x000000CC
	sw s7, 24(sp)
	
	li a0, 0x00000011
	li a1, 0x00000002
	
	sll s7, a0, a1
	sw s7, 28(sp)
	
	slli s7, a0, 3
	sw s7, 32(sp)
	
	li a0, 0x00000088
	li a1, 0x00000001
	
	srl s7, a0, a1
	sw s7, 36(sp)
	
	srli s7, a0, 2
	sw s7, 40(sp)
	
	
	
	
	