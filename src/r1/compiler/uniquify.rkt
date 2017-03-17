#lang racket

(require "../../util/env.rkt")
(require "../../util/error.rkt")
(require "../../util/uniqsym.rkt")

(provide uniquify)

; Ensures all identifiers are unique to avoid shadowing.
; R1 -> R1
(define (aux env)
  (lambda (exp)
    (let ([rec (aux env)])
      (match exp
        [(? integer?) exp]
        [(? symbol?) `,(lookup env exp)]
        [`(read) exp]
        [`(let ([,var ,val]) ,body)
         (let ([fresh-var (uniqsym var)])
           `(let ([,fresh-var ,val]) ,((aux (extend-env env var fresh-var)) body)))]
        [`(- ,e) `(- ,(rec e))]
        [`(+ ,e1 ,e2) `(+ ,(rec e1) ,(rec e2))]
        [else (syntax-error 'uniquify exp)]))))

(define (uniquify exp)
  (match exp
    [`(program ,e) `(program ,((aux (new-env)) e))]
    [else (syntax-error 'uniquify exp)]))
