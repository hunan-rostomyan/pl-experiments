#lang racket

(provide syntax-error)

(define (syntax-error pass exp)
  (error pass "can't recognize '~a'" exp))
