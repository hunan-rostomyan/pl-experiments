# Language R<sub>1</sub>

An extension of R<sub>0</sub> with variables.

## Syntax

| Nonterminal | Expression |
| --- | --- |
| exp | int \| var \| (<b>read</b>) \| (<b>-</b> exp) \| (<b>+</b> exp exp) \| (<b>let</b> ([var exp]) exp) |
| R<sub>1</sub> | (<b>program</b> exp)

## Implementation

### Intermediate languages

#### Language C<sub>0</sub>

An intermediary langauge distinguishable from R<sub>1</sub> by the absence of shadowed variables (due to `uniquify`) and of nested expressions (due to `flatten`).

| Nonterminal | Expression |
| --- | --- |
| arg | int \| var |
| exp | arg \| (<b>read</b>) \| (<b>-</b> arg) \| (<b>+</b> arg arg) |
| stmt | (<b>assign</b> var exp) \| (<b>return</b> arg) |
| C<sub>0</sub> | (<b>program</b> (var<sup>*</sup>) stmt<sup>+</sup>) |

#### Language X86<sup>*</sup>

A pseudo-X86 language distinguishable from the target language by the presence of AST nodes of form (<b>var</b> exp) and of a program form that still uses a list of variables.

| Nonterminal | Expression |
| --- | --- |
| arg | (<b>int</b> int) \| (<b>reg</b> register) \| (<b>deref</b> register int) \| (<b>var</b> var) |
| instr | (<b>addq</b> arg arg) \| (<b>subq</b> arg arg) \| (<b>negq</b> arg) \| (<b>movq</b> arg arg) \| (<b>callq</b> label) \|<br>  (<b>pushq</b> arg) \| (<b>popq</b> arg) \| (<b>retq</b>) |
| x86<sup>\*</sup> | (<b>program</b> (var<sup>\*</sup>) instr<sup>+</sup>) |

#### Language X86<sub>0</sub>

The *abstract syntax* of the target language.

| Nonterminal | Expression |
| --- | --- |
| arg | (<b>int</b> int) \| (<b>reg</b> register) \| (<b>deref</b> register int) |
| instr | (<b>addq</b> arg arg) \| (<b>subq</b> arg arg) \| (<b>negq</b> arg) \| (<b>movq</b> arg arg) \| (<b>callq</b> label) \|<br>  (<b>pushq</b> arg) \| (<b>popq</b> arg) \| (<b>retq</b>) |
| x86<sub>0</sub> | (<b>program</b> int instr<sup>+</sup>) |

### Passes

#### Eliminate shadowed variables

The `uniquify` pass takes an R<sub>1</sub> program that contains shadowed variables and returns a semantically-equivalent program
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

#### Turn nested expressions into sequences of unnested expressions

The `flatten` pass takes an R<sub>1</sub> program that contains nested expressions (e.g. `(+ 4 (- 2))`) and produces a C<sub>0</sub> program that contains no nested expressions.

```racket
(flatten `(program (+ 5 (- 1))))

; Output
'(program
  (t.1 t.0)
  (assign t.0 (- 1))
  (assign t.1 (+ 5 t.0))
  (return t.1))
```
