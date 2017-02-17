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
      (error 'interp-R1 "unbound identifier '~a'" var)
      (let ([head (car env)][rest (cdr env)])
        (if (eq? (car head) var)
            (cdr head)
            (lookup rest var)))))

; Test case: should output 42
(define program1 `(program
                   (let ([x 32])
                     (+ (let ([x 10]) x) x))))

; Ensures all identifiers are unique to avoid shadowing.
(define (uniquify alist)
  (lambda (exp)
    (match exp
      [(? symbol?) `,(lookup alist exp)]
      [(? integer?) exp]
      [`(let ([,x ,e]) ,body)
       (let ([new (gensym x)])
       `(let ([,new ,e]) ,((uniquify (extend-env alist x new)) body)))]
      [`(program ,exp)
       `(program ,((uniquify alist) exp))]
      [`(,op ,es ...)
       `(,op ,@(map (uniquify alist) es))])))
