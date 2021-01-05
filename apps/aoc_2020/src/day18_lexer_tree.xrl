Definitions.
Rules.
%% a number
[0-9]+ : {token, {number, list_to_integer(TokenChars)}}.
%% open/close parens
\( : {token, {'(', TokenLine}}.
\) : {token, {')', TokenLine}}.
%% arithmetic operators
\+ : {token, {'+', TokenLine}}.
\- : {token, {'-', TokenLine}}.
\* : {token, {'*', TokenLine}}.
\/ : {token, {'/', TokenLine}}.
%% white space
[\s\n\r\t]+           : skip_token.

Erlang code.