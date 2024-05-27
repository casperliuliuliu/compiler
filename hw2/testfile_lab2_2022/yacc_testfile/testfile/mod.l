%{
#include "y.tab.h" // Remember to includ this header file
#include <stdio.h>
int lineNum = 0;
%}
Digit [0-9]+
absolute       [aA][bB][sS][oO][lL][uU][tT][eE]
and            [aA][nN][dD]
begin          [bB][eE][gG][iI][nN]
break          [bB][rR][eE][aA][kK]
case           [cC][aA][sS][eE]
const          [cC][oO][nN][sS][tT]
continue       [cC][oO][nN][tT][iI][nN][uU][eE]
do             [dD][oO]
else           [eE][lL][sS][eE]
end            [eE][nN][dD]
for            [fF][oO][rR]
function       [fF][uU][nN][cC][tT][iI][oO][nN]
if             [iI][fF]
mod            [mM][oO][dD]
nil            [nN][iI][lL]
not            [nN][oO][tT]
object         [oO][bB][jJ][eE][cC][tT]
of             [oO][fF]
or             [oO][rR]
program        [pP][rR][oO][gG][rR][aA][mM]
then           [tT][hH][eE][nN]
to             [tT][oO]
var            [vV][aA][rR]
while          [wW][hH][iI][lL][eE]
array          [aA][rR][rR][aA][yY]
integer        [iI][nN][tT][eE][gG][eE][rR]
double         [dD][oO][uU][bB][lL][eE]
write          [wW][rR][iI][tT][eE]
writeln        [wW][rR][iI][tT][eE][lL][nN]
string         [sS][tT][rR][iI][nN][gG]
float          [fF][lL][oO][aA][tT]
read           [rR][eE][aA][dD]
symbols ==|<=|>=|[\[\]\,\=\<\>]

reserved_words {absolute}|{and}|{begin}|{break}|{case}|{const}|{continue}|{do}|{else}|{end}|{for}|{function}|{if}|{mod}|{nil}|{not}|{object}|{of}|{or}|{program}|{then}|{to}|{var}|{while}|{array}|{integer}|{double}|{write}|{writeln}|{string}|{float}|{read}
identifiers [a-zA-Z_][a-zA-Z0-9_]{0,14}

%x COMMENT MULTILINE
%%
"(*"                        { BEGIN(MULTILINE); }
<MULTILINE>"*)"             { BEGIN(INITIAL); }
<MULTILINE>\n               { lineNum++; }
<MULTILINE>.                { }  // Count every character within multiline comments

program     { return PROGRAM; }
var         { return VAR; }
begin       { return BEGIM; }
end         { return END; }

{reserved_words} {
    yylval.strVal = strdup(yytext);
    return RESERVE;
}
{identifiers}       { /*printf("===============%s\n", yytext);*/ yylval.strVal = strdup(yytext); return IDENTIFIER; }
{symbols}           { /*printf("sssssssssssssss%s\n", yytext);*/ yylval.strVal = strdup(yytext); return SYMBOL; }

{Digit}	{
    sscanf(yytext, "%f", &yylval.floatVal); // floatVal is defined in "calc.y"
    return NUMBER;
}

\+ { return PLUS; }
\- { return MINUS; }
\* { return MUL; }
\/ { return DIV; }
\( { return LP; }
\) { return RP; }
";"         { return SEMICOLON; }
"."         { return DOT; }
":="        { return ASSIGN; }
":"         { return DECLARE; }
\n { lineNum++; return NEWLINE; }
[ \t\r]+ { /*printf("empty...\n");*/ }
.  { return yytext[0]; }
%%

int yywrap(){
    return 1;
}
