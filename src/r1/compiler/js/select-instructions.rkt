#lang racket

(provide select-instructions-js)

(define (sel-instr-aux-expr exp)
  (match exp
    [(? integer?) exp]
    [(? symbol?) exp]
    [`(read) exp]
    [`(let ([,x ,e]) ,body) exp]
    [`(- ,e) exp]
    [`(+ ,e1 ,e2) exp]))

(define (sel-instr-aux expressions new)
  (if (empty? expressions) new
      (let ([first (car expressions)] [rest (cdr expressions)])
        (sel-instr-aux rest (append new (sel-instr-aux-expr first))))))

(define (select-instructions-js exp)
  (match exp
    [`(program ,e)
     `(program ,(sel-instr-aux-expr e '()))]
    [else (error 'select-instructions-js "unrecognized expression ~a" exp)]))
