#lang racket

(require "../../util/env.rkt")
(require "../../util/list.rkt")

(provide flatten)

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
