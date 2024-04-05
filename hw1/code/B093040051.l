%{
#include<stdio.h>
unsigned charCount = 0,lineCount = 0;
void print_char();

%}

reserved_words [aA][bB][sS][oO][lL][uU][tT][eE]|[aA][nN][dD]|[bB][eE][gG][iI][nN]|[bB][rR][eE][aA][kK]|[cC][aA][sS][eE]|[cC][oO][nN][sS][tT]|[cC][oO][nN][tT][iI][nN][uU][eE]|[dD][oO]|[eE][lL][sS][eE]|[eE][nN][dD]|[fF][oO][rR]|[fF][uU][nN][cC][tT][iI][oO][nN]|[iI][fF]|[mM][oO][dD]|[nN][iI][lL]|[nN][oO][tT]|[oO][bB][jJ][eE][cC][tT]|[oO][fF]|[oO][rR]|[pP][rR][oO][gG][rR][aA][mM]|[tT][hH][eE][nN]|[tT][oO]|[vV][aA][rR]|[wW][hH][iI][lL][eE]|[aA][rR][rR][aA][yY]|[iI][nN][tT][eE][gG][eE][rR]|[dD][oO][uU][bB][lL][eE]|[wW][rR][iI][tT][eE]|[wW][rR][iI][tT][eE][lL][nN]|[sS][tT][rR][iI][nN][gG]|[fF][lL][oO][aA][tT]|[rR][eE][aA][dD]
identifiers [a-zA-Z_][a-zA-Z0-9_]{0,14}
symbols [;:()\[\]+\-*/.=<>]
String 	[a-zA-Z]+
space [ ]
eol \n
Symbol   .

%%
{reserved_words}    {printf("reserved_words : \'%s\'\n", yytext);}
{identifiers}   {printf("identifiers : \'%s\'\n", yytext);}
{String}	{charCount += yyleng; printf("String : \'%s\'\n", yytext);}

{space} {}
{eol}   {lineCount++;}
{Symbol} {print_char();}
%%

int main()
{
	yylex(); 	
	printf("\n\nThe number of characters: %d\n",charCount);
	printf("The number of lines: %d\n", lineCount);
	return 0;
}

void print_char()
{
	printf("[In print_char]Symbol:\'%s\'\n",yytext);charCount++;
}