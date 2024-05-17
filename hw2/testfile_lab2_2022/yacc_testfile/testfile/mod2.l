%{
#include "y.tab.h"
#include <stdio.h>
int lineNum = 0;
%}

digit       [0-9]
letter      [a-zA-Z]
id          {letter}({letter}|{digit})*
ws          [ \t]+
newline     \n
comment     \(\*[^*]*\*+([^*][^*]*\*+)*\)

%%

"program"           { return PROGRAM; }
"var"               { return VAR; }
"begin"             { return BEGIN; }
"end"               { return END; }
"array"             { return ARRAY; }
"of"                { return OF; }
"integer"           { return INTEGER; }
"do"                { return DO; }
"to"                { return TO; }
"for"               { return FOR; }
{ws}                { /* ignore whitespace */ }
{newline}           { /* ignore newlines */ }
{comment}           { /* ignore comments */ }
{digit}+            { yylval.num = atoi(yytext); return NUMBER; }
{id}                { yylval.str = strdup(yytext); return IDENTIFIER; }
"+"|"-"|"*"|"/"     { return *yytext; }
","|";"|":"|"["|"]" { return *yytext; }
.                   { return yytext[0]; }
":="                { return ASSIGN; }
"="                 { return EQ; }
"<="                { return LE; }
">="                { return GE; }
\( { return LP; }
\) { return RP; }

%%