%{
#include<stdio.h>
unsigned charCount = 1,lineCount = 1;
void output_result(const char* code_type, int an_flag, int invalid_flag);
%}


reserved_words [aA][bB][sS][oO][lL][uU][tT][eE]|[aA][nN][dD]|[bB][eE][gG][iI][nN]|[bB][rR][eE][aA][kK]|[cC][aA][sS][eE]|[cC][oO][nN][sS][tT]|[cC][oO][nN][tT][iI][nN][uU][eE]|[dD][oO]|[eE][lL][sS][eE]|[eE][nN][dD]|[fF][oO][rR]|[fF][uU][nN][cC][tT][iI][oO][nN]|[iI][fF]|[mM][oO][dD]|[nN][iI][lL]|[nN][oO][tT]|[oO][bB][jJ][eE][cC][tT]|[oO][fF]|[oO][rR]|[pP][rR][oO][gG][rR][aA][mM]|[tT][hH][eE][nN]|[tT][oO]|[vV][aA][rR]|[wW][hH][iI][lL][eE]|[aA][rR][rR][aA][yY]|[iI][nN][tT][eE][gG][eE][rR]|[dD][oO][uU][bB][lL][eE]|[wW][rR][iI][tT][eE]|[wW][rR][iI][tT][eE][lL][nN]|[sS][tT][rR][iI][nN][gG]|[fF][lL][oO][aA][tT]|[rR][eE][aA][dD]
identifiers [a-zA-Z_][a-zA-Z0-9_]{0,14}
symbols :=|==|<=|>=|[\;\:\(\)\[\]\+\-\*\/\.\=\<\>]
real_num [+-]?([0-9]+\.[0-9]+)|([0-9]+(\.[0-9]*)?)([eE][+-]?[0-9]+)

quoted_string \'([^\']|\'\'){0,28}\'

invalid_identifiers [a-zA-Z0-9#]+
invalid_real_num [+-]?[0-9\.eE]+
invalid_string [a-zA-Z0-9\'\"]+
space [ ]
eol \n
Other .

%x COMMENT
%%
"(*"                        { BEGIN(COMMENT); }
<COMMENT>"*)"               { BEGIN(INITIAL); }
<COMMENT>\n                 { lineCount++; }
<COMMENT>.                  { /* Ignore everything within comments except new lines */ }

{reserved_words}    { output_result("reserved word",0,0); charCount += yyleng; }
{identifiers}       { output_result("ID",1,0); charCount += yyleng; }
{symbols}           { output_result("symbol",0,0); charCount += yyleng; }
{real_num}          { output_result("real number",0,0); charCount += yyleng; }

{invalid_identifiers}            { output_result("ID",1,1); charCount += yyleng; }
{invalid_real_num}            { output_result("real number",1,1); charCount += yyleng; }
{invalid_string}            { output_result("string",1,1); charCount += yyleng; }
{space}             { charCount += yyleng; }
{eol}               { lineCount++; charCount = 1; }
{Other}             { output_result("OOOOOO", 0, 1); charCount += yyleng; }

%%

int main()
{
	yylex(); 	
	return 0;
}


void output_result(const char* code_type, int an_flag, int invalid_flag)
{
	if (an_flag == 0 && invalid_flag == 0)
		printf("Line: %d, 1st char: %d, \"%s\" is a \"%s\".\n",lineCount, charCount, yytext, code_type);
	else if (an_flag == 1 && invalid_flag == 0)
		printf("Line: %d, 1st char: %d, \"%s\" is an \"%s\".\n",lineCount, charCount, yytext, code_type);
	else
		printf("Line: %d, 1st char: %d, \"%s\" is an invalid \"%s\".\n",lineCount, charCount, yytext, code_type);
}
/*
[-+]?(([1-9]\d*|0)\.\d+|\d+\.\d+)([eE][-+]?\d+)?|[-+]?0\.0([eE][-+]?\d+)?
### uncomment this before you submit

void output_result(const char* code_type)
{
	printf("%s : \"%s\"\n",code_type, yytext);
}

*/
