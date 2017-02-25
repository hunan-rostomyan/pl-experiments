#lang racket

(provide add-unique)


; Adds an element to a list, unless it's already in it.
(define (add-unique x lst)
  (if (memv x lst) lst (cons x lst)))
