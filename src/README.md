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
