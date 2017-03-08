#lang racket

(provide select-instructions)

; Select-instructions takes a C0 program and emits a pseudo-X86* program. Its primary
; responsibility is the conversion of arithmetic operations, but it also translates
; (read)s and (return)s.
; C0 -> x86*
(define (select-int var val)
  (list `(movq (int ,val) (var ,var))))

(define (select-var var val)
  (list `(movq (var ,val) (var ,var))))

(define (select-neg var arg)
  (let ([name (if (symbol? arg) 'var 'int)])
    (list
     `(movq (,name ,arg) (var ,var))
     `(negq (var ,var)))))

(define (select-add var arg1 arg2)
  (let ([type1 (if (symbol? arg1) 'var 'int)]
        [type2 (if (symbol? arg2) 'var 'int)]
        [dontmove? (or (eqv? arg1 var) (eqv? arg2 var))]
        [theotherone (if (eqv? arg1 var) arg2 arg1)])
    (append
     (if dontmove? (list) (list `(movq (,type1 ,arg1) (var ,var))))
     (list `(addq (,type2 ,(if dontmove? theotherone arg2)) (var ,var))))))

(define (select-read var)
  (list
   `(callq read_int)
   `(movq (reg rax) (var ,var))))

(define (sel-instr-aux statements new)
  (if (empty? statements) new
      (let ([first (car statements)] [rest (cdr statements)])
        (match first
          [`(assign ,var ,val)
           (match val
             [(? integer?)
              (sel-instr-aux rest (append new (select-int var val)))]
             [(? symbol?)
              (sel-instr-aux rest (append new (select-var var val)))]
             [`(read)
              (sel-instr-aux rest (append new (select-read var)))]
             [`(- ,arg)
              (sel-instr-aux rest (append new (select-neg var arg)))]
             [`(+ ,arg1 ,arg2)
              (sel-instr-aux rest (append new (select-add var arg1 arg2)))])]))))

(define (select-instructions exp)
  (match exp
    [`(program ,varlist ,statements ... ,return)
     `(program ,varlist ,@(sel-instr-aux statements '()) (movq (var ,(cadr return)) (reg rax)) (retq))]))
