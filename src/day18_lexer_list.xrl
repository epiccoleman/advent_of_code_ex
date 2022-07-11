Definitions.

Rules.

[0-9]+      : {token, {int,  TokenLine, list_to_integer(TokenChars)}}.
[+-/*]      : {token, {operator, TokenLine, TokenChars}}.
\(          : {token, {'(',  TokenLine}}.
\)          : {token, {')',  TokenLine}}.
[\s\t\n\r]+ : skip_token.

Erlang code.