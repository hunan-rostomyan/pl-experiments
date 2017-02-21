.global main

main:
	pushq %rbp
	movq %rsp, %rbp
	subq $24, %rsp

	movq $2, -8(%rbp)
	movq $3, -16(%rbp)
	movq -8(%rbp), %rax
	movq %rax, -24(%rbp)
	movq -16(%rbp), %rax
	addq %rax, -24(%rbp)
	movq -24(%rbp), %rax

	movq %rax, %rdi
	callq print_int
	addq $24, %rsp
	popq %rbp
	movl $0, %eax
	retq
