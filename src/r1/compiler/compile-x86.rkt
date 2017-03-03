#lang racket

(require 2htdp/batch-io)

(require "assign-homes.rkt")
(require "flatten.rkt")
(require "patch-instructions.rkt")
(require "print-x86.rkt")
(require "select-instructions.rkt")
(require "stack.rkt")
(require "uniquify.rkt")
(require "../../util/env.rkt")
(require "../../util/list.rkt")

(provide compile-x86)

(define (compile-x86 exp)
  (print-x86
   (patch-instructions
    (assign-homes
     (select-instructions
      (flatten
       (uniquify exp)))))))
