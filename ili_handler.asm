.globl my_ili_handler

.text
.align 4, 0x90

my_ili_handler:
	#first save all registers
	pushq %rax
	pushq %rbx
	pushq %rcx
	pushq %rdx	
	pushq %r8
	pushq %r9
	pushq %r10
	pushq %r11
	pushq %r12
	pushq %r13
	pushq %r14
	pushq %r15
	pushq %rsi
	pushq %rbp
	pushq %rsp

	movq $0, %rdi
	movq $0, %rax
	movq $0,%rdx
	movq 120(%rsp),%rdx #load pointer to opcode to %rdx
	movq (%rdx), %rdx # load opcode to %rcs
	cmpb $0x0f, %dl # if first byte is 0x0f continue to two_byte, else its one_byte
	jne one_byte

	movb %dh, %al #put second byte of %rdx in first byte of %rax
	movq %rax, %rdi # move rax to rdi now rdi (first argument for what_to_do) has the byte after 0x0f
	call what_to_do
	cmpq $0, %rax #if return value of what_to_do is 0 go to original handler
	je original_handler
	jmp my_handler # else we move return value to rdi

one_byte:
	movb %dl, %al # now rax has the opcode
	movq %rax, %rdi # move the opcode as argument to what_to_do
	call what_to_do
	cmpq $0, %rax # just like said earlier in line 35
	je original_handler
	jmp my_handler

original_handler:
	popq %rsp #restore registers
	popq %rbp
	popq %rsi
	popq %r15
	popq %r14
	popq %r13
	popq %r12
	popq %r11
	popq %r10
	popq %r9
	popq %r8
	popq %rdx
	popq %rcx
	popq %rbx
	popq %rax
	jmp * old_ili_handler
	jmp finish

my_handler:
	movq %rax, %rdi # put return value of what_to_do in registe %rdi
	popq %rsp #restore registers
	popq %rbp
	popq %rsi
	popq %r15
	popq %r14
	popq %r13
	popq %r12
	popq %r11
	popq %r10
	popq %r9
	popq %r8
	popq %rdx
	popq %rcx
	popq %rbx
	popq %rax
	addq $2, (%rsp) #move stack 2 bytes up before returning
  
finish:
	iretq
