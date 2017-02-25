#lang racket

(require "../../util/env.rkt")


(define (interp-R1 env e)
  (match e
    [(? fixnum?) e]
    [`(let ([,var ,val]) ,body)
     (interp-R1 (extend-env env var (interp-R1 env val)) body)]
    [`(read)
     (let ([r (read)])
       (cond [(fixnum? r) r]
             [else (error 'interp-R1 "input not an integer ~a" r)]))]
    [`(- ,e) (- (interp-R1 env e))]
    [`(+ ,e1 ,e2) (+
                   (interp-R1 env e1)
                   (interp-R1 env e2))]
    [(? symbol?) (lookup env e)]
    [`(program ,e) (interp-R1 env e)]
    [else (error 'interp-R1 "unrecognized expression ~a" e)]))

(define (interp e)
  (interp-R1 (new-env) e))
