#lang racket/base

(require rackunit "optimizer.rkt")

; Make sure the optimizer preserves r0 interpreter tests.
(check-equal? (optimize `(program 5)) 5)

(check-equal? (optimize `(program (- 5))) -5)
(check-equal? (optimize `(program (- (- 5)))) 5)

(check-equal? (optimize `(program (+ 1 2))) 3)
(check-equal? (optimize `(program (+ (+ 1 1) (+ (+ 1 2) 1)))) 6)

(check-equal? (optimize `(program (+ 5 (- 3)))) 2)
(check-equal? (optimize `(program (+ (- 2) (- 3)))) -5)

(check-equal? (optimize `(program 5)) 5)

; Confirm that the optimizations are taking place.
(check-equal? (optimize `(program (+ 5 (read)))) `(+ 5 (read)))

; Even though the expression contains free variables (e.g. `(read)`),
; the optimizer detects that certain arguments are independent
; of those and reduces them.
(check-equal? (optimize `(program (+ 5 (+ 2 (read))))) `(+ 7 (read)))
(check-equal? (optimize `(program (+ 5 (+ (read) 2)))) `(+ 7 (read)))
(check-equal? (optimize `(program (+ 5 (+ (- 2) (read))))) `(+ 3 (read)))
(check-equal? (optimize `(program (+ 5 (+ (read) (- 2))))) `(+ 3 (read)))
(check-equal? (optimize `(program (+ 5 (+ 2 (+ (read) 3))))) `(+ 10 (read)))
