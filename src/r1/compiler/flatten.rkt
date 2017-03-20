#lang racket

(require "../../util/env.rkt")
(require "../../util/list.rkt")
(require "../../util/uniqsym.rkt")

(provide flatten)

; Takes a uniquified program in R1 and produces a flattened C0 program.
; R1 -> C0
(define (aux asgns vars exp let?)
  (match exp
    [(? symbol?)
     (values exp asgns vars)]
    [(? integer?)
     (values exp asgns vars)]
    [`(read)
     (let ([temp (uniqsym 't)])
       (values temp
               (cons `(assign ,temp (read)) asgns)
               (cons temp vars)))]
    [`(- ,e)
     (let-values ([(fnd asg vlist) (aux asgns vars e #f)])
       (if let?
           (values `(- ,fnd) asg vlist)
           (let ([temp (uniqsym 't)])
             (values temp
                     (append asg (list `(assign ,temp (- ,fnd))))
                     (cons temp vlist)))))]
    [`(+ ,e1 ,e2)
     (let-values ([(fnd1 asg1 vlist1)(aux asgns vars e1 #f)]
                  [(fnd2 asg2 vlist2) (aux asgns vars e2 #f)])
       (if let?
           (values `(+ ,fnd1 ,fnd2) (append asg1 asg2) (append vlist1 vlist2))
           (let ([temp (uniqsym 't)])
             (values temp
                     (append asg1 asg2 (list `(assign ,temp (+ ,fnd1 ,fnd2))))
                     (cons temp (append vlist1 vlist2))))))]
    [`(let ([,x ,e]) ,body)
     (let-values ([(fnd1 asg1 vlist1) (aux asgns vars e x)]
                  [(fnd2 asg2 vlist2) (aux asgns vars body #f)])
       (values fnd2
               (append asg1 (list `(assign ,x ,fnd1)) asg2)
               (add-unique x (append vlist1 vlist2))))]))

(define (flatten exp)
  (let-values ([(e asgns vars) (aux '() '() (cadr exp) #f)])
          (if (empty? vars)
              `(program ,vars (return ,e))
              `(program ,vars ,@asgns (return ,e)))))
