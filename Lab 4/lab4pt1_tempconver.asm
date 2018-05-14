
	.data
	
		const5: .float 5.0
		const9: .float 9.0
		const32: .float 32.0
		const27315: .float 273.15
		
		Celsius: .float 0
		Kelvin: .float 0
		Fahren: .float 0
		
		printFahren: .asciz "Fahrenheight temperature: "
		printCelsius: .asciz "Celsius temperature: "
		printKelvin: .asciz "Kelvin temperature: "
		
		newline: .asciz "\r\n"
	
	.text
	
	li	a7, 4	
	la	a0, printFahren
	ecall
	
	li	a7, 6	
	ecall
	fmv.s	ft1,fa0	
	
	fsw f10, Fahren, t0
	jal conversion
	
	li a7, 4
	la a0, newline
	ecall
	li a7, 4
	la a0, printCelsius
	ecall
	flw fa0, Celsius, t0
	li a7, 2
	ecall
	li a7, 4
	la a0, newline
	ecall
	li a7, 4
	la a0, printKelvin
	ecall
	flw fa0, Kelvin, t0
	li a7, 2
	ecall
	j End
	
	conversion:
	flw f0, Fahren, t0
	flw f1, const5, t0 #5
	flw f2, const9, t0, #9
	flw f3, const32, t0 #32
	flw f4, const27315, t0 #273.15
	fsub.s f0, f0, f3
	fmul.s f0, f0, f1
	fdiv.s f0, f0, f2
	fsw f0, Celsius, t0
        fadd.s f0, f0, f4
	fsw f0, Kelvin, t0
	ret
	End:
