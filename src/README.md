# pl-experiments
Programming Language Experiments

## Language R<sub>0</sub>

| Nonterminal | Expression |
| --- | --- |
| exp | int \| (<b>read</b>) \| (<b>-</b> exp) \| (<b>+</b> exp exp) |
| R<sub>0</sub> | (<b>program</b> exp) |

## Language R<sub>1</sub>

| Nonterminal | Expression |
| --- | --- |
| exp | int \| var \| (<b>read</b>) \| (<b>-</b> exp) \| (<b>+</b> exp exp) \| (<b>let</b> ([var exp]) exp) |
| R<sub>1</sub> | (<b>program</b> exp)

## Language C<sub>0</sub>

An intermediary langauge distinguishable from R<sub>1</sub> by the absence of shadowed variables (due to `uniquify`) and of nested expressions (due to `flatten`).

| Nonterminal | Expression |
| --- | --- |
| arg | int \| var |
| exp | arg \| (<b>read</b>) \| (<b>-</b> arg) \| (<b>+</b> arg arg) |
| stmt | (<b>assign</b> var exp) \| (<b>return</b> arg) |
| C<sub>0</sub> | (<b>program</b> (var<sup>*</sup>) stmt<sup>+</sup>) |

## Language X86<sup>*</sup>

A pseudo-X86 language distinguishable from the target language by the presence of AST nodes of form (<b>var</b> exp) and of a program form that still uses a list of variables.

| Nonterminal | Expression |
| --- | --- |
| arg | (<b>int</b> int) \| (<b>reg</b> register) \| (<b>deref</b> register int) \| (<b>var</b> var) |
| instr | (<b>addq</b> arg arg) \| (<b>subq</b> arg arg) \| (<b>negq</b> arg) \| (<b>movq</b> arg arg) \| (<b>callq</b> label) \|<br>  (<b>pushq</b> arg) \| (<b>popq</b> arg) \| (<b>retq</b>) |
| x86<sub>0</sub> | (<b>program</b> (var<sup>*</sup>) instr<sup>+</sup>) |

## Language X86<sub>0</sub>

The *abstract syntax* of the target language.

| Nonterminal | Expression |
| --- | --- |
| arg | (<b>int</b> int) \| (<b>reg</b> register) \| (<b>deref</b> register int) |
| instr | (<b>addq</b> arg arg) \| (<b>subq</b> arg arg) \| (<b>negq</b> arg) \| (<b>movq</b> arg arg) \| (<b>callq</b> label) \|<br>  (<b>pushq</b> arg) \| (<b>popq</b> arg) \| (<b>retq</b>) |
| x86<sub>0</sub> | (<b>program</b> int instr<sup>+</sup>) |


## Sources

* Abelson, H., Sussman, G.J. (1996) *Structure and Interpretation of Computer Programs*, 2nd Edition, MIT.
* Friedman, D., Wand, M. (2008) *Essentials of Programming Languages*, 3rd Edition, MIT.
* Siek, J. (2017) *Essentials of Compilation: An Incremental Approach*, Lecture Notes.
