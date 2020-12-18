Nonterminals list elems elem.
Terminals '(' ')' int operator.
Rootsymbol list.

list -> '(' ')'       : [].
list -> '(' elems ')' : '$2'.

elems -> elem           : ['$1'].
elems -> elem elems : ['$1'|'$2'].

elem -> int  : extract_token('$1').
elem -> operator : extract_token('$1').
elem -> list : '$1'.

Erlang code.

extract_token({_Token, _Line, Value}) -> Value.