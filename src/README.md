# pl-experiments
Programming Language Experiments

## Language R<sub>0</sub>

A language with integral primitives, arbitrarily-nested additions and subtractions, and a facility to grab integral input from the user.

| Nonterminal | Expression |
| --- | --- |
| exp | int \| (<b>read</b>) \| (<b>-</b> exp) \| (<b>+</b> exp exp) |
| R<sub>0</sub> | (<b>program</b> exp) |

## Language R<sub>1</sub>

An extension of R<sub>0</sub> with variables. This is the language we'll be compiling down to assembly.

| Nonterminal | Expression |
| --- | --- |
| exp | int \| var \| (<b>read</b>) \| (<b>-</b> exp) \| (<b>+</b> exp exp) \| (<b>let</b> ([var exp]) exp) |
| R<sub>1</sub> | (<b>program</b> exp)

## Language X86<sup>*</sup>

A pseudo-X86 language distinguishable from the target language by the presence of AST nodes of form (<b>var</b> exp) and of a program form that still uses a list of variables.

| Nonterminal | Expression |
| --- | --- |
| arg | (<b>int</b> int) \| (<b>reg</b> register) \| (<b>deref</b> register int) \| (<b>var</b> var) |
| instr | (<b>addq</b> arg arg) \| (<b>subq</b> arg arg) \| (<b>negq</b> arg) \| (<b>movq</b> arg arg) \| (<b>callq</b> label) \|<br>  (<b>pushq</b> arg) \| (<b>popq</b> arg) \| (<b>retq</b>) |
| x86<sup>*</sup> | (<b>program</b> (var<sup>*</sup>) instr<sup>+</sup>) |

## Language X86<sub>0</sub>

The *abstract syntax* of the target language.

| Nonterminal | Expression |
| --- | --- |
| arg | (<b>int</b> int) \| (<b>reg</b> register) \| (<b>deref</b> register int) |
| instr | (<b>addq</b> arg arg) \| (<b>subq</b> arg arg) \| (<b>negq</b> arg) \| (<b>movq</b> arg arg) \| (<b>callq</b> label) \|<br>  (<b>pushq</b> arg) \| (<b>popq</b> arg) \| (<b>retq</b>) |
| x86<sub>0</sub> | (<b>program</b> int instr<sup>+</sup>) |


## Sources

* Abelson, H., Sussman, G.J. (1996) *Structure and Interpretation of Computer Programs*, 2nd Edition, MIT.
* Brown, A., Wilson, G. (2011) *The Architecture Of Open Source Applications*, Volume 1.
* Brown, A., Wilson, G. (2012) *The Architecture Of Open Source Applications*, Volume 2.
* Friedman, D., Wand, M. (2008) *Essentials of Programming Languages*, 3rd Edition, MIT.
* Ghuloum, A. (2006) *An Incremental Approach to Compiler Construction*, Technical Report, Chicago.
* Ghuloum, A. (2006) *Compilers: Backend to Frontend and Back to Front Again*, Tutorial.
* Lattner, C. (2011) "LLVM". In (Brown, Wilson 2011), Chapter 11.
* Marlow, S., Peyton-Jones, S. (2012) "The Glasgow Haskell Compiler". In (Brown, Wilson 2012), Chapter 5.
* Siek, J. (2017) *Essentials of Compilation: An Incremental Approach*, Lecture Notes.
