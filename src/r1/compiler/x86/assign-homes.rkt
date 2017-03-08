#lang racket

(require "../stack.rkt")
(require "../../../util/env.rkt")

(provide assign-homes)

; Assign-homes takes a pseudo-x86 program with var arguments and places all of the variables
; on the stack. Its output is still in pseudo-x86.
; x86* -> x86*
(define (assign-homes-aux-instr instr deref)
  (match instr
    [`(callq ,label) (list `(callq ,label))]
    [`(,unop ,arg)
     (list `(,unop ,(if (eq? (car arg) 'var)
                        `(deref rbp ,(lookup deref (cadr arg)))
                        arg)))]
    [`(,binop ,arg1 ,arg2)
     (list `(,binop ,(if (eq? (car arg1) 'var)
                         `(deref rbp ,(lookup deref (cadr arg1)))
                         arg1)
                    ,(if (eq? (car arg2) 'var)
                         `(deref rbp ,(lookup deref (cadr arg2)))
                         arg2)))]))

(define (assign-homes-aux instr new deref)
  (if (empty? instr) new
      (assign-homes-aux (cdr instr) (append new (assign-homes-aux-instr (car instr) deref)) deref)))


(define (assign-homes exp)
  (match exp
    [`(program ,varlist ,instructions ... ,ret)
     (let ([deref (map-to-stack varlist)])
       `(program ,(* 8 (length deref)) ,(assign-homes-aux instructions '() deref) ,ret))]))
