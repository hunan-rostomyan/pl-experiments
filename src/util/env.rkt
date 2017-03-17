#lang racket

(provide new-env)
(provide extend-env)
(provide lookup)


; Create an empty environment.
(define (new-env) (list))

; Takes an environment, a variable and a value, returns
; a new environment where the variable is bound to the
; value.
(define (extend-env env var val)
  (cons (cons var val) env))

; Given an environment and a variable, returns the value
; associated with the variable in the environment. If no
; such value is found, an error is raised.
(define (lookup env var)
  (if (empty? env)
      (error (format "Unbound identifier '~a'" var))
      (let ([head (car env)][rest (cdr env)])
        (if (equal? (symbol->string (car head)) (symbol->string var))
            (cdr head)
            (lookup rest var)))))
