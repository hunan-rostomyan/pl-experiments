#lang racket

(require "../../util/env.rkt")

(provide uniquify)

; Ensures all identifiers are unique to avoid shadowing.
; R1 -> R1
(define (uniquify-aux env)
  (lambda (exp)
    (match exp
      [(? integer?) exp]
      [(? symbol?) `,(lookup env exp)]      
      [`(read) exp]
      [`(let ([,x ,e]) ,body)
       (let ([new (gensym x)])
       `(let ([,new ,e]) ,((uniquify-aux (extend-env env x new)) body)))]
      [`(- ,e) `(- ,((uniquify-aux env) e))]
      [`(+ ,e1 ,e2) `(+
                     ,((uniquify-aux env) e1)
                     ,((uniquify-aux env) e2))]
      [else (error 'uniquify "unrecognized expression ~a" exp)])))

(define (uniquify exp)
  (match exp
    [`(program ,e) `(program ,((uniquify-aux (new-env)) e))]
    [else (error 'uniquify "unrecognized expression ~a" exp)]))
