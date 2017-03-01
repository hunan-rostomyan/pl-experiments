#lang racket/base

(require rackunit "interpreter.rkt")
(require "interpreter.rkt")

(check-equal? (interp `(program 5)) 5)

(check-equal? (interp `(program (- 5))) -5)
(check-equal? (interp `(program (- (- 5)))) 5)

(check-equal? (interp `(program (+ 1 2))) 3)
(check-equal? (interp `(program (+ (+ 1 1) (+ (+ 1 2) 1)))) 6)

(check-equal? (interp `(program (+ 5 (- 3)))) 2)
(check-equal? (interp `(program (+ (- 2) (- 3)))) -5)

(check-equal? (interp `(program 5)) 5)
