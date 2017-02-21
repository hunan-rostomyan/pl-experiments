#lang racket

; Environment
; -----------
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
        (if (equal? (symbol->string (car head)) (symbol->string var))
            (cdr head)
            (lookup rest var)))))

; Adds x to lst unless it's already in it.
(define (add-unique x lst)
  (if (memv x lst) lst (cons x lst)))

; An interpreter for R1
; ---------------------
(define (interp-R1 env e)
  (match e
    [(? fixnum?) e]
    [`(let ([,var ,val]) ,body)
     (interp-R1 (extend-env env var (interp-R1 env val)) body)]
    [`(read)
     (let ([r (read)])
       (cond [(fixnum? r) r]
             [else (error 'interp-R1 "input not an integer ~a" r)]))]
    [`(- ,e) (- (interp-R1 env e))]
    [`(+ ,e1 ,e2) (+
                   (interp-R1 env e1)
                   (interp-R1 env e2))]
    [(? symbol?) (lookup env e)]
    [`(program ,e) (interp-R1 env e)]
    [else (error 'interp-R1 "unrecognized expression ~a" e)]))

(define (interp e)
  (interp-R1 (new-env) e))


; Test cases
; ----------
; Should output 42
(define program1 `(program
                   (let ([x 32])
                     (+ (let ([x 10]) x) x))))

; Should output 42
(define program2 `(program
                   (let ([x (+ (- 10) 11)])
                     (+ x 41))))


; A compiler from R1 to x86
; -------------------------
; Ensures all identifiers are unique to avoid shadowing.
; R1 -> R1
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

; Takes a uniquified program in R1 and produces a flattened C0 program.
; R1 -> C0
(define (flatten-aux assignments varlist exp let?)
  (match exp
    [(? symbol?)
     (values exp assignments varlist)]
    [(? integer?)
     (values exp assignments varlist)]
    [`(read)
     (let ([temp (gensym 't)])
       (values temp
               (cons `(assign ,temp (read)) assignments)
               (cons temp varlist)))]
    [`(- ,e)
     (let-values ([(fnd asg vlist) (flatten-aux assignments varlist e #f)])
       (if let?
           (values `(- ,fnd) asg vlist)
           (let ([temp (gensym 't)])
             (values temp
                     (append asg (list `(assign ,temp (- ,fnd))))
                     (cons temp vlist)))))]
    [`(+ ,e1 ,e2)
     (let-values ([(fnd1 asg1 vlist1)(flatten-aux assignments varlist e1 #f)]
                  [(fnd2 asg2 vlist2) (flatten-aux assignments varlist e2 #f)])
       (if let?
           (values `(+ ,fnd1 ,fnd2) (append asg1 asg2) (append vlist1 vlist2))
           (let ([temp (gensym 't)])
             (values temp
                     (append asg1 asg2 (list `(assign ,temp (+ ,fnd1 ,fnd2))))
                     (cons temp (append vlist1 vlist2))))))]
    [`(let ([,x ,e]) ,body)
     (let-values ([(fnd1 asg1 vlist1) (flatten-aux assignments varlist e x)]
                  [(fnd2 asg2 vlist2) (flatten-aux assignments varlist body #f)])
       (values fnd2
               (append asg1 (list `(assign ,x ,fnd1)) asg2)
               (add-unique x (append vlist1 vlist2))))]))

(define (flatten exp)
  (let-values ([(flattened assignments varlist) (flatten-aux '() '() (cadr exp) #f)])
          (if (empty? varlist)
              `(program ,varlist (return ,flattened))
              `(program ,varlist ,@assignments (return ,flattened)))))


; Select-instructions takes a C0 program and emits a pseudo-X86* program. Its primary
; responsibility is the conversion of arithmetic operations, but it also translates
; (read)s and (return)s.
; C0 -> x86*
(define (select-int var val)
  (list `(movq (int ,val) (var ,var))))

(define (select-neg var arg)
  (let ([name (if (symbol? arg) 'var 'int)])
    (list
     `(movq (,name ,arg) (var ,var))
     `(negq (var ,var)))))

(define (select-add var arg1 arg2)
  (let ([type1 (if (symbol? arg1) 'var 'int)]
        [type2 (if (symbol? arg2) 'var 'int)]
        [dontmove? (or (eqv? arg1 var) (eqv? arg2 var))]
        [theotherone (if (eqv? arg1 var) arg2 arg1)])
    (append
     (if dontmove? (list) (list `(movq (,type1 ,arg1) (var ,var))))
     (list `(addq (,type2 ,(if dontmove? theotherone arg2)) (var ,var))))))

(define (select-read var)
  (list
   `(callq read_int)
   `(movq (reg rax) (var ,var))))

(define (sel-instr-aux statements new)
  (if (empty? statements) new
      (let ([first (car statements)] [rest (cdr statements)])
        (match first
          [`(assign ,var ,val)
           (match val
             [(? integer?)
              (sel-instr-aux rest (append new (select-int var val)))]
             [`(read)
              (sel-instr-aux rest (append new (select-read var)))]
             [`(- ,arg)
              (sel-instr-aux rest (append new (select-neg var arg)))]
             [`(+ ,arg1 ,arg2)
              (sel-instr-aux rest (append new (select-add var arg1 arg2)))])]))))

(define (select-instructions exp)
  (match exp
    [`(program ,varlist ,statements ... ,return)
     `(program ,@(sel-instr-aux statements '()) (movq (var ,(cadr return)) (reg rax)) (retq))]))
