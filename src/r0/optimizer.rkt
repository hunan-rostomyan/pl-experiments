#lang racket

(provide optimize)

(define (pe-neg exp)
  (match exp
    [(? fixnum?) (- exp)]
    [`(- ,(app pe-arith e)) e]
    [else `(- ,exp)]))

(define (pe-add r1 r2)
  (cond [(fixnum? r1)
         (match r2
           ; (+ int int)
           [(? fixnum?) (+ r1 r2)]
           ; (+ int (read))
           [`(read) `(+ ,r1 (read))]
           ; (+ int (+ EXP EXP))
           [`(+ ,(app pe-arith s1) ,(app pe-arith s2))
                  ; (+ int (+ int int))
            (cond [(and (fixnum? s1) (fixnum? s2)) (+ r1 (+ s1 s2))]
                  ; (+ int (+ int EXP))
                  [(fixnum? s1) `(+ ,(+ r1 s1) ,s2)]
                  ; (+ int (+ EXP int)
                  [(fixnum? s2) `(+ ,(+ r1 s2) ,s1)])])]
        [else `(+ ,r1 ,r2)]))

(define (pe-arith exp)
  (match exp
    [(? fixnum?) exp]
    [`(read) `(read)]
    [`(- ,(app pe-arith r1)) (pe-neg r1)]
    [`(+ ,(app pe-arith r1) ,(app pe-arith r2))
     (pe-add r1 r2)]
    [else (error 'optimize-R0 "unrecognized expression ~a" exp)]))

(define (optimize exp)
  (match exp
    [`(program ,e) (pe-arith e)]
    [else (error 'optimize-R0 "unrecognized expression ~a" exp)]))
