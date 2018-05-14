
	.data
	
	.text
	
main:

	addi sp, sp, -44

	li a0, 0x01234567	
	li a1, 0x11223344
	
	add s7, a0, a1		
	sw s7, 0(sp)		#sp(0) 
	
	sub s7, a1, a0
	sw s7, 4(sp)		#sp(1)   
	
	addi s7, a0, 6
	sw s7, 8(sp)		#sp(2) 
	
	li a0, 0x01234567	
	li a1, 0x11223344	
	
	and s7, a0, a1		
	sw s7, 12(sp)		
	
	andi s7, a0, 0x00000006
	sw, s7, 16(sp)
	
	or s7, a0, a1
	sw s7, 20(sp)
	
	ori s7, a0, 0x11223344
	sw s7, 24(sp)
	
	li a0, 0x01234567
	li a1, 0x00000040
	
	sll s7, a0, a1
	sw s7, 28(sp)
	
	slli s7, a0, 3
	sw s7, 32(sp)
	
	li a0, 0x11223344
	li a1, 0x00000040
	
	srl s7, a0, a1
	sw s7, 36(sp)
	
	srli s7, a0, 2
	sw s7, 40(sp)
	
	
	
	
	