#lang racket

(require "flatten.rkt")
(require "print-js.rkt")
(require "select-instructions-js.rkt")
(require "uniquify.rkt")

(provide compile-js)

(define (compile-js exp)
  (print-js
   (select-instructions-js
    (flatten
     (uniquify exp)))))
