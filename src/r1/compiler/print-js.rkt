#lang racket

(require 2htdp/batch-io)

(provide print-js)

(define (print-js-aux-instr instr)
  (match instr
    [`(assign ,var ,val)
     (match val
       [`(- ,e)
        (format "\tlet ~a = -~a;" var e)]
       [`(+ ,e1 ,e2)
        (format "\tlet ~a = ~a + ~a;" var e1 e2)]
       ; the plus attempts to convert the input into a number
       [`(input) (format "\tlet ~a = +readline();" var)]
       [else (format "\tlet ~a = ~a;" var val)])]
    [`(return ,var)
     (format "\tprint(~a);" var)]
    [else (error 'print-js "unrecognized instruction ~a" instr)]))

(define (print-js-aux instr str)
  (if (empty? instr) str
      (print-js-aux
       (cdr instr)
       (string-append str (print-js-aux-instr (car instr)) "\n"))))

(define (print-prelude)
  (string-append
   (format "(function() {\n")
   (format "\t\"use strict\";\n")))

(define (print-conclusion)
  (format "})();"))

(define (print-js exp)
  (match exp
    [`(program ,instructions ...)
      (write-file "program.js" (string-append
                                      (print-prelude)
                                      (print-js-aux (car instructions) "")
                                      (print-conclusion)))]))
