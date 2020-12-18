Definitions.

Rules.

[0-9]+      : {token, {int,  TokenLine, TokenChars}}.
[+-/*]      : {token, {operator, TokenLine, TokenChars}}.
\(          : {token, {'(',  TokenLine}}.
\)          : {token, {')',  TokenLine}}.
[\s\t\n\r]+ : skip_token.

Erlang code.