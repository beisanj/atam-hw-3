.global get_element_from_matrix, inner_prod, matrix_multiplication


# 1 - enter (update rsp and rbp) 
# 2 - back up registers and/or read parameters 
# 3 - execute the function 
# 4 - restore registers 
# 5 - ret


# params order: rdi, rsi, rdx, rcx, r8, r9


# #1 param: martix = rdi 
# #2 param: n = rsi (esi)
# #3 param: row = rdx (edx)
# #4 param: col = rcx (ecx)

get_element_from_matrix:
	d1_HW2:	
	pushq %rbp 
	movq %rsp, %rbp
	# we use rdx for mul, and this overwrites rdx. to avoid that we have to store the content of the param rdx elsewhere - we dont need to save it. all's well
	# - now the question is should i use a reg for this or should i just save it on the stack?? ill use a reg in the meantime 
	# rax will do and i dont need to back it up
	xor %rax, %rax
	mov %esi, %eax  
	mul %edx
	add %ecx, %eax
	movl (%rdi,%rax,4), %eax

	leave
	ret 

	# we can use a loop that adds "row" n times 
	# we can use mul 
	# idk which of these options is more efficient 
	# ill go with mul for now



# params order: rdi, rsi, rdx, rcx, r8, r9


# #1 param: mat_a = rdi 
# #2 param: mat_b = rsi 
# #3 param: row_a = rdx (edx)
# #4 param: col_b = rcx (ecx)
# #5 param: max_col_a = r8d
# #6 param: max_col_b = r9d

inner_prod:

	#entering
	
	pushq %rbp
	movq %rsp, %rbp


	#backing up paramters

	sub $32, %rsp
	movq %rdi, -8(%rbp)
	movl %edx, -12(%rbp)
	movl %r8d, -16(%rbp)

	movq %rsi, -24(%rbp)
	movl %ecx, -28(%rbp)
	movl %r9d, -32(%rbp)

	#backing up registers

	sub $8, %rsp

	movl %ebx, -36(%rbp)
	movl %r12d, -40(%rbp)

	xor %ebx,%ebx 
	xor %r12d, %r12d

	#local variables

	sub $4, %rsp 


	loop_HW2:

		movq -8(%rbp), %rdi
		movl -16(%rbp), %esi
		movl -12(%rbp), %edx
		movl %ebx, %ecx
		call get_element_from_matrix

		#store the result in a variable 
		movl %eax, -44(%rbp) 

		movq -24(%rbp), %rdi
		movl -32(%rbp), %esi
		movl %ebx, %edx 
		movl -28(%rbp), %ecx
		call get_element_from_matrix

		movl -44(%rbp), %edx

		mul %edx
		d5_HW2:
		add %eax, %r12d
		inc %ebx
		cmp %ebx, -16(%rbp)
		ja loop_HW2


	
	movl %r12d, %eax
	
	#restore backed up registers

	movl  -36(%rbp), %ebx
	movl  -40(%rbp), %r12d

	#leaving

	leave
	ret



# #1 param: res = rdi 
# #2 param: mat_a = rsi 
# #3 param: mat_b = rdx 
# #4 param: m = ecx
# #5 param: n = r8d
# #6 param: p = r9d
# #7 param: q = on the stack (new rbp+16)

matrix_multiplication:
	
	#entering
	
	pushq %rbp
	movq %rsp, %rbp
	d8_HW2:
	#checking params
	cmpl %r9d, %r8d
	jne false_HW2

	#backing up paramters

	sub $36, %rsp
	movq %rsi, -8(%rbp)
	movl %ecx, -12(%rbp)
	movl %r8d, -16(%rbp)

	movq %rdx, -24(%rbp)
	movl %r9d, -28(%rbp)

	movq %rdi, -36(%rbp)

	#backing up registers
	sub $8, %rsp
	movl %ebx, -40(%rbp)
	movl %r12d,-44(%rbp)
	xor %r12d, %r12d 


	#local variables
	


	loop2_HW2:
		xor %ebx, %ebx
		loop3_HW2:

			movq -8(%rbp), %rdi
			movq -24(%rbp), %rsi
			movl %r12d, %edx
			movl %ebx, %ecx
			movl -16(%rbp), %r8d
			movl 16(%rbp), %r9d
			call inner_prod

			movq -36(%rbp), %rdi   
			movl 16(%rbp), %esi
			movl %ebx, %edx
			movl %r12d, %ecx
			movl %eax, %r8d
			call set_element_in_matrix

			inc %ebx
			cmp 16(%rbp), %ebx
			jb loop3_HW2

		inc %r12d
		cmp %r12d, -12(%rbp)
		ja loop2_HW2

	
	#restore backed up registers


	movl -40(%rbp) ,%ebx 
	movl -44(%rbp), %r12d 
	

	#leave 

	mov $1, %rax
	jmp end_HW2


	false_HW2:
		mov $0, %rax
		jmp end_HW2


	end_HW2:
		leave 
		ret 

