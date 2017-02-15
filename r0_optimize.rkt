; Optimizing compiler for R0
(define (pe-neg r)
  (cond [(fixnum? r) (- 0 r)]
        [else (match r
                [`(- ,(app pe-arith r1)) r1]
                [else `(- ,r)])]))

(define (pe-add r1 r2)
  (cond [(fixnum? r1)
         (match r2
           ; (+ int int)
           [(? fixnum?) (+ r1 r2)]
           ; (+ int (+ s1 s2))
           [`(+ ,(app pe-arith s1) ,(app pe-arith s2))
                  ; (+ int (+ int int))
            (cond [(and (fixnum? s1) (fixnum? s2)) (+ r1 (+ s1 s2))]
                  ; (+ int (+ int EXP))
                  [(fixnum? s1) `(+ ,(+ r1 s1) ,s2)]
                  ; (+ int (+ EXP int)
                  [(fixnum? s2) `(+ ,(+ r1 s2) ,s1)])])]
        [else `(+ ,r1 ,r2)]))

(define (pe-arith e)
  (match e
    [(? fixnum?) e]
    [`(read) `(read)]
    [`(- ,(app pe-arith r1))
     (pe-neg r1)]
    [`(+ ,(app pe-arith r1) ,(app pe-arith r2))
     (pe-add r1 r2)]))
