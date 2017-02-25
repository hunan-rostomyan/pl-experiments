#lang racket

(define (interp-R0 e)
  (match e
    [(? fixnum?) e]
    [`(read)
     (let ([r (read)])
       (cond [(fixnum? r) r]
             [else (error 'interp-R0 "input not an integer ~a" r)]))]
    [`(- ,e) (- (interp-R0 e))]
    [`(+ ,e1 ,e2) (+ (interp-R0 e1) (interp-R0 e2))]
    [`(program ,e) (interp-R0 e)]
    [else (error 'interp-R0 "unrecognized expression ~a" e)]))
