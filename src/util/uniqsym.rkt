#lang racket

(provide ord)
(provide uniqsym)

; Generate a unique identifier given any identifier. This is useful for
; mocking calls to gensym because the identifiers it generates can be
; predicted in advance.
(define ord 0)
(define (uniqsym var)
  (begin
    (let ([new (format "~a.~a" var ord)])
      (set! ord (+ ord 1))
      new)))
