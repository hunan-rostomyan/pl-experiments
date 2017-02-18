# pl-experiments
Programming Language Experiments

## Language R<sub>0</sub>

exp ::= int | (<b>read</b>) | (<b>-</b> exp) | (<b>+</b> exp exp)

R<sub>0</sub>  ::= (<b>program</b> exp)

## Language R<sub>1</sub>

exp ::= int | var | (<b>read</b>) | (<b>-</b> exp) | (<b>+</b> exp exp) | (<b>let</b> ([var exp]) exp)

R<sub>1</sub> ::= (<b>program</b> exp)

## Language C<sub>0</sub>

arg ::= int | var

exp ::= arg | (<b>read</b>) | (<b>-</b> arg) | (<b>+</b> arg arg)

stmt ::= (<b>assign</b> var exp) | (<b>return</b> arg)

C0 ::= (<b>program</b> (var*) stmt+)

## Sources

* Friedman, D., Wand, M. (2008) *Essentials of Programming Languages*, Third Edition, MIT.
* Siek, J. (2017) *Essentials of Compilation: An Incremental Approach*, Course Notes.
