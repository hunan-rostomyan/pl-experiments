#lang racket/base

(require rackunit "interpreter.rkt")

(check-equal? (interp `(program 5)) 5)

(check-equal? (interp `(program (- 5))) -5)
(check-equal? (interp `(program (- (- 5)))) 5)

(check-equal? (interp `(program (+ 1 2))) 3)
(check-equal? (interp `(program (+ (+ 1 1) (+ (+ 1 2) 1)))) 6)

(check-equal? (interp `(program (+ 5 (- 3)))) 2)
(check-equal? (interp `(program (+ (- 2) (- 3)))) -5)

(check-equal? (interp `(program (let ([m 5]) m))) 5)
(check-equal? (interp `(program
                        (let ([m 0])
                          (let ([m 5])
                            m))))
              5)

(check-equal? (interp `(program
                        (let ([m 2])
                          (let ([n 3])
                            (+ m n)))))
              5)

(check-equal? (interp `(program
                        (let ([m (- 5)])
                          m)))
              -5)

(check-equal? (interp `(program
                        (let ([m (+ 2 3)])
                          m)))
              5)
