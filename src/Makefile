.PHONY: figure2.4

figure2.4:
	@gcc -S runtime.c
	@gcc figure2.4.s runtime.s
	@./a.out

program:
	@gcc -S runtime.c
	@gcc program.s runtime.s
	@./a.out
