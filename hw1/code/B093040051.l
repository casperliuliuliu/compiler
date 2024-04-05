%{
#include<stdio.h>
unsigned charCount = 0,lineCount = 0;
void output_result(const char* code_type);
%}


reserved_words [aA][bB][sS][oO][lL][uU][tT][eE]|[aA][nN][dD]|[bB][eE][gG][iI][nN]|[bB][rR][eE][aA][kK]|[cC][aA][sS][eE]|[cC][oO][nN][sS][tT]|[cC][oO][nN][tT][iI][nN][uU][eE]|[dD][oO]|[eE][lL][sS][eE]|[eE][nN][dD]|[fF][oO][rR]|[fF][uU][nN][cC][tT][iI][oO][nN]|[iI][fF]|[mM][oO][dD]|[nN][iI][lL]|[nN][oO][tT]|[oO][bB][jJ][eE][cC][tT]|[oO][fF]|[oO][rR]|[pP][rR][oO][gG][rR][aA][mM]|[tT][hH][eE][nN]|[tT][oO]|[vV][aA][rR]|[wW][hH][iI][lL][eE]|[aA][rR][rR][aA][yY]|[iI][nN][tT][eE][gG][eE][rR]|[dD][oO][uU][bB][lL][eE]|[wW][rR][iI][tT][eE]|[wW][rR][iI][tT][eE][lL][nN]|[sS][tT][rR][iI][nN][gG]|[fF][lL][oO][aA][tT]|[rR][eE][aA][dD]
identifiers [a-zA-Z_][a-zA-Z0-9_]{0,14}
symbols [;:()\[\]+\-*/.=<>]
real_num [+-]?([0-9]+\.[0-9]+)|([0-9]+(\.[0-9]*)?)([eE][+-]?[0-9]+)?
quoted_string \'([^\']|\'\'){0,28}\'

String 	[a-zA-Z]+
space [ ]
eol \n
Other   .

%x COMMENT
%%
"(*"                        { BEGIN(COMMENT); }
<COMMENT>"*)"               { BEGIN(INITIAL); }
<COMMENT>.|\n               { /* Ignore everything within comments */ }

{reserved_words}    {output_result("reserved word");charCount += yyleng;}
{identifiers}   {charCount += yyleng;printf("identifiers : \'%s\'\n", yytext);}
{symbols}   {charCount += yyleng;printf("symbols : \'%s\'\n", yytext);}
{real_num}   {charCount += yyleng;printf("real_num : \'%s\'\n", yytext);}

{String}	{charCount += yyleng; printf("String : \'%s\'\n", yytext);}
{space} {charCount += yyleng;}
{eol}   {lineCount++;charCount=0;}
{Other} {charCount += yyleng;printf("Other : \'%s\'\n", yytext);}
%%

int main()
{
	yylex(); 	
	return 0;
}

/*
### uncomment this before you submit

void output_result(const char* code_type)
{
	printf("Line: %d, 1st char: %d, \"%s\" is a \"%s\".\n",lineCount+1, charCount+1, yytext, code_type);
}
*/

void output_result(const char* code_type)
{
	printf("%s : \"%s\"\n",code_type, yytext);
}