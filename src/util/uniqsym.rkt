#lang racket

(provide ord)
(provide uniqsym)

; Generate a unique symbol given any symbol. Similar to `gensym`, but
; predictable and of a specific form that makes it easier to read.
(define ord 0)
(define (uniqsym var)
  (begin
    (let ([new (format "~a.~a" var ord)])
      (set! ord (+ ord 1))
      new)))
