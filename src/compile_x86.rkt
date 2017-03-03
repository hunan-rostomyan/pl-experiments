#lang racket

(require "r1/compiler/compile-x86.rkt")

(compile-x86 `(program (let ([x (read)]) (let ([y (read)]) (+ x y)))))
