#lang racket

(provide select-instructions-js)

(define (sel-instr-aux statements new)
  (if (empty? statements) new
      (let ([first (car statements)] [rest (cdr statements)])
        (match first
          [`(assign ,var ,val)
           (match val
             [`(read)
              (sel-instr-aux rest (append new (list `(assign ,var (input)))))]
             [else
              (sel-instr-aux rest (append new (list first)))])]
          [`(return ,var) first]
          [else (error 'compile-js "unrecognized expression ~a" first)]))))

(define (select-instructions-js exp)
  (match exp
    [`(program ,varlist ,statements ... ,return)
     `(program ,(append (sel-instr-aux statements '()) (list return)))]))
