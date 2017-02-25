.global main

main:
	pushq %rbp
	movq %rsp, %rbp
	subq $56, %rsp

	movq $1, -24(%rbp)
	movq $46, -32(%rbp)
	movq -24(%rbp), %rax
	movq %rax, -40(%rbp)
	addq $7, -40(%rbp)
	movq $4, -48(%rbp)
	movq -40(%rbp), %rax
	addq %rax, -48(%rbp)
	movq -40(%rbp), %rax
	movq %rax, -56(%rbp)
	movq -32(%rbp), %rax
	addq %rax, -56(%rbp)
	movq -48(%rbp), %rax
	movq %rax, -8(%rbp)
	negq -8(%rbp)
	movq -56(%rbp), %rax
	movq %rax, -16(%rbp)
	movq -8(%rbp), %rax
	addq %rax, -16(%rbp)
	movq -16(%rbp), %rax

	movq %rax, %rdi
	callq print_int
	addq $56, %rsp
	popq %rbp
	movl $0, %eax
	retq
