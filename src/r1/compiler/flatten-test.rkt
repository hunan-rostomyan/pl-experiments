#lang racket/base

(require rackunit "flatten.rkt")
(require "../../util/uniqsym.rkt")

(define (genvar ord)
  (string->symbol (format "t.~a" ord)))

(check-equal?
 (flatten `(program 5))
 `(program () (return 5)))

(let ([t0 (genvar ord)][t1 (genvar (+ ord 1))])
  (check-equal?
   (flatten `(program (- (read))))
   `(program
     (,t1 ,t0)
     (assign ,t0 (read))
     (assign ,t1 (- ,t0))
     (return ,t1))))

(let ([t0 (genvar ord)])
  (check-equal?
   (flatten `(program (- 5)))
   `(program (,t0) (assign ,t0 (- 5)) (return ,t0))))
