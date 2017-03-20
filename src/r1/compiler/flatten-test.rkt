#lang racket/base

(require rackunit "flatten.rkt")

(check-equal? (flatten `(program 5)) `(program () (return 5)))
