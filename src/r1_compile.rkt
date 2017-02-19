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
        (if (eq? (car head) var)
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