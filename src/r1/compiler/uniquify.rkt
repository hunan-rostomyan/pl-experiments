#lang racket

(require "../../util/env.rkt")

(provide uniquify)


; Ensures all identifiers are unique to avoid shadowing.
; R1 -> R1
(define (uniquify alist)
  (lambda (exp)
    (match exp
      [(? symbol?) `,(lookup alist exp)]
      [(? integer?) exp]
      [`(let ([,x ,e]) ,body)
       (let ([new (gensym x)])
       `(let ([,new ,e]) ,((uniquify (extend-env alist x new)) body)))]
      [`(program ,exp)
       `(program ,((uniquify alist) exp))]
      [`(,op ,es ...)
       `(,op ,@(map (uniquify alist) es))])))
