#lang racket

(provide interp)

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

(define (interp exp)
  (match exp
    [`(program ,e) (interp-R0 e)]
    [else (error 'interp-R0 "unrecognized expression ~a" exp)]))
