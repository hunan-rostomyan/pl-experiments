#lang racket

(provide patch-instructions)


; Patch-instructions takes a pseudo-x86 program and transforms into an abstract x86
; program by making sure each instruction references at most a single memory location.
; x86* -> x86 (abstract)
(define (patch-instructions-aux-instr instr)
  (match instr
    [`(,binop ,arg1 ,arg2)
     (let ([leftderef? (equal? (car arg1) 'deref)]
           [rightderef? (equal? (car arg2) 'deref)])
       (if (and leftderef? rightderef?)
           (list
            `(movq ,arg1 (reg rax))
            `(,binop (reg rax) ,arg2))
           (list instr)))]
    [else (list instr)]))

(define (patch-instructions-aux instr new)
  (if (empty? instr) new
      (patch-instructions-aux (cdr instr) (append new (patch-instructions-aux-instr (car instr))))))

(define (patch-instructions exp)
  (match exp
    [`(program ,framesize ,instructions ... ,ret)
     ; taking car of instructions because we've been wrapping those in a list
     `(program ,framesize ,(patch-instructions-aux (car instructions) '()) ,ret)]))
