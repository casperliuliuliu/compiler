%{
#include "y.tab.h"
#include <stdio.h>
%}
Digit [0-9]+

%%
[pP][rR][oO][gG][rR][aA][mM] {return PROGRAM;}
{Digit}		{ sscanf(yytext, "%f", &yylval.floatVal); return NUMBER;}
\+          {return PLUS;}
\-          {return MINUS;}
\*          {return MUL;}
\/          {return DIV;}
\(			{return LP;}
\)			{return RP;}
\n			{return NEWLINE;}
.			{return yytext[0];}
%%

int yywrap(){
    return 1;
}
