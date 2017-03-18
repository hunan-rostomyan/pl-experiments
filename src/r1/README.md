# Language R<sub>1</sub>

An extension of R<sub>0</sub> with variables.

## Syntax

| Nonterminal | Expression |
| --- | --- |
| exp | int \| var \| (<b>read</b>) \| (<b>-</b> exp) \| (<b>+</b> exp exp) \| (<b>let</b> ([var exp]) exp) |
| R<sub>1</sub> | (<b>program</b> exp)

## Implementation

### Passes

#### Eliminate shadowed variables (`uniquify`)

The `uniquify` pass takes an R1 program that contains shadowed variables and returns a semantically-equivalent program
without shadowed variables. It does this by

1. generating a fresh variable (using `uniqsym`) for each variable it finds in a let expression, and
2. substituting all occurrences of the old variable in the body of the let expression with the new variable.

```racket
(uniquify
  `(program
    (let ([x 1])       ; (1) x is first declared
      (+ x
         (let ([x 2])  ; x is redeclared, shadowing the x declared at (1)
           (- x))))))

; Output
'(program
  (let ((x.0 1))       ; x.0 is declared
    (+ x.0
       (let ((x.1 2))  ; x.1 is declared (x.0 still holds the value 1)
         (- x.1)))))
```
