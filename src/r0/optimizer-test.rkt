#lang racket/base

(require rackunit "optimizer.rkt")

(check-equal? (optimize `(program 5)) 5)

(check-equal? (optimize `(program (- 5))) -5)
(check-equal? (optimize `(program (- (- 5)))) 5)

(check-equal? (optimize `(program (+ 1 2))) 3)
(check-equal? (optimize `(program (+ (+ 1 1) (+ (+ 1 2) 1)))) 6)

(check-equal? (optimize `(program (+ 5 (- 3)))) 2)
(check-equal? (optimize `(program (+ (- 2) (- 3)))) -5)

(check-equal? (optimize `(program 5)) 5)
