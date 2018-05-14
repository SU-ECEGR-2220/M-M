
	.data
	
	const3: .word 3
	const10: .word 10
	const20: .word 20


	.text
	
main:

	li	a2,3 		#call 3
	jal	fib 
	sw	a0,const3,a7

	li	a2,10 		#call 10
	jal	fib 
	sw	a0,const10,a7

	li	a2,20 		#call 20
	jal	fib 
	sw	a0,const20,a7

	li 	a3,10
	ecall

	fib:
	addi 	sp,sp,-12	#create allocation of memory on stack
	sw 	ra,0(sp)
	sw 	s0,4(sp)
	sw 	s1,8(sp)

	add 	s0,a2,zero
	addi	t1,zero,1
	
	bne 	s0,zero,not0
		li a0,0
		j functionReturn
		
	not0:
	bne 	s0,t1,not1or0
		li a0,1
		j functionReturn

	not1or0:
	addi 	a2,s0,-1
	jal 	fib
	add 	s1,zero,a0
	addi 	a2,s0,-2
	jal 	fib
	add 	a0,a0,s1 

	functionReturn:		#deallocate memory on stack
	lw 	ra,0(sp)
	lw 	s0,4(sp)
	lw 	s1,8(sp)
	addi 	sp,sp,12
	jr 	ra,0

