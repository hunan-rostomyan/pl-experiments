#lang racket

(require "assign-homes.rkt")
(require "flatten.rkt")
(require "patch-instructions.rkt")
(require "print-x86.rkt")
(require "select-instructions.rkt")
(require "stack.rkt")
(require "uniquify.rkt")
(require "../../util/env.rkt")
(require "../../util/list.rkt")


(define (compile exp)
  (select-instructions (flatten exp)))
