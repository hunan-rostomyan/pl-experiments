#lang racket/base

(require rackunit "uniquify.rkt")
(require "../../util/uniqsym.rkt")

(let ([output (uniquify `(program (let ([x 1]) x)))])
  (let ([new (format "~a.~a" 'x (- ord 1))])
    (check-equal? output `(program (let ([,new 1]) ,new)))))

(let ([output (uniquify `(program (let ([x 1]) (let ([x 2]) (+ x x)))))])
  (let ([new1 (format "~a.~a" 'x (- ord 2))])
    (let ([new2 (format "~a.~a" 'x (- ord 1))])
      (check-equal? output `(program (let ([,new1 1]) (let ([,new2 2]) (+ ,new2 ,new2))))))))

(let ([output (uniquify `(program (let ([x 1]) (let ([y 2]) (+ x y)))))])
  (let ([new1 (format "~a.~a" 'x (- ord 2))])
    (let ([new2 (format "~a.~a" 'y (- ord 1))])
      (check-equal? output `(program (let ([,new1 1]) (let ([,new2 2]) (+ ,new1 ,new2))))))))
