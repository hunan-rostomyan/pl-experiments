.global main

main:
	pushq %rbp
	movq %rsp, %rbp
	subq $24, %rsp

	callq read_int
	movq %rax, -8(%rbp)
	callq read_int
	movq %rax, -16(%rbp)
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
