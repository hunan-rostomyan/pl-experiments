.PHONY: figure2.4

figure2.4:
	@gcc -S runtime.c
	@gcc figure2.4.s runtime.s
	./a.out

program:
	@gcc -S runtime.c
	@gcc program.s runtime.s
	./a.out

compile-x86:
	racket compile_js.rkt
	gcc -S runtime.c
	gcc program.s runtime.s
	./a.out

