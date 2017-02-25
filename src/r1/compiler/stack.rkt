#lang racket

(require "../../util/env.rkt")

(provide map-to-stack)


; Sorts list of symbols, assigning them to unique locations
; on the stack.
(define (map-to-stack-aux varlist cur env)
  (if (empty? varlist) env
      (let ([first (car varlist)][rest (cdr varlist)])
        (map-to-stack-aux rest (+ -8 cur) (extend-env env first cur)))))

(define (map-to-stack varlist)
  (let ([sorted (sort varlist symbol<?)])
    (map-to-stack-aux sorted -8 (new-env))))
