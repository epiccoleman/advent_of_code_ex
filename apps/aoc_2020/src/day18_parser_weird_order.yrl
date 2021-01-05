Nonterminals expr term factor.
Terminals number '+' '*' '(' ')'.
Rootsymbol expr.

expr -> expr '*' term : {mult, '$1', '$3'}.
expr -> term : '$1'.

term -> factor '+' term : {plus, '$1', '$3'}.
term -> factor : '$1'.

factor -> '(' expr ')' : '$2'.
factor -> number : '$1'.