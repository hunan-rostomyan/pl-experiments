#lang racket

(require "flatten.rkt")
(require "uniquify.rkt")
(require "js/print.rkt")
(require "js/select-instructions.rkt")

(provide compile-js)

(define (compile-js exp)
  (print-js
   (select-instructions-js
    (flatten
     (uniquify exp)))))
