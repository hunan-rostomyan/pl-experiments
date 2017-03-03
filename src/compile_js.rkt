#lang racket

(require "r1/compiler/compile-js.rkt")

(compile-js `(program (let ([x (read)]) (let ([y (read)]) (+ x y)))))
