#lang racket

(provide program3)


; Should output 42
(define program1 `(program
                   (let ([x 32])
                     (+ (let ([x 10]) x) x))))

; Should output 42
(define program2 `(program
                   (let ([x (+ (- 10) 11)])
                     (+ x 41))))

; Should output 42
(define program3 `(program
                   (let ([v 1])
                   (let ([w 46])
                   (let ([x (+ v 7)])
                   (let ([y (+ 4 x)])
                   (let ([z (+ x w)])
                   (+ z (- y)))))))))
