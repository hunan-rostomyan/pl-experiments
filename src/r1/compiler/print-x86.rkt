#lang racket

(require 2htdp/batch-io)

(provide print-x86)


; Print-x86 converts the abstract x86 syntax into x86 assembly. The resultant
; program can be compiled with the runtime system to print the program value to
; stdout.
; x86 (abstract) -> x86 (concrete)
(define (print-preamble framesize)
  (string-append
   ".global main\n\nmain:\n"
   (format "\t~a\n" "pushq %rbp")
   (format "\t~a\n" "movq %rsp, %rbp")
   (format "\t~a\n" (format "subq $~a, %rsp" framesize))))

(define (print-postamble framesize)
  (string-append
   (format "\t~a\n" "movq %rax, %rdi")
   (format "\t~a\n" "callq print_int")
   (format "\t~a\n" (format "addq $~a, %rsp" framesize))
   (format "\t~a\n" "popq %rbp")
   (format "\t~a\n" "movl $0, %eax")
   (format "\t~a\n" "retq")))

(define (print-arg arg)
  (match arg
    [`(int ,int) (format "$~a" int)]
    [`(reg ,reg) (format "%~a" reg)]
    [`(deref ,reg ,int) (format "~a(%~a)" int reg)]
    [else (error 'print-x86 "unrecognized argument ~a" arg)]))

(define (print-x86-aux-instr instr)
  (match instr
    [`(callq ,label)
     (format "\tcallq ~s" label)]
    [`(,unop ,arg)
     (string-append (format "\t~a ~a" unop (print-arg arg)))]
    [`(,binop ,arg1 ,arg2)
     (string-append (format "\t~a ~a, ~a" binop (print-arg arg1) (print-arg arg2)))]
    [else (error 'print-x86 "unrecognized instruction ~a" instr)]))

(define (print-x86-aux instr str)
  (if (empty? instr) str
      (print-x86-aux (cdr instr) (string-append str "\n" (print-x86-aux-instr (car instr))))))

(define (print-x86 exp)
  (match exp
    [`(program ,framesize ,instructions ... ,ret)
     (write-file "../../program.s" (string-append
                              (print-preamble framesize)
                              (format "~a\n\n" (print-x86-aux (car instructions) ""))
                              (print-postamble framesize)))]))
