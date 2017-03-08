#lang racket

(require 2htdp/batch-io)

(require "flatten.rkt")
(require "stack.rkt")
(require "uniquify.rkt")
(require "x86/assign-homes.rkt")
(require "x86/patch-instructions.rkt")
(require "x86/print.rkt")
(require "x86/select-instructions.rkt")
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
