.global main

main:
	movq 	$10, %rax
	addq 	$22, %rax

	movq 	%rax, %rdi
	callq 	print_int

	movl	$0, %eax
	retq
