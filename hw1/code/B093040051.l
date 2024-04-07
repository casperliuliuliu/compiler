%{
#include<stdio.h>
unsigned charCount = 1,lineCount = 1;
void output_result(const char* code_type, int an_flag, int invalid_flag);
void output_with_format(const char* code_type,const char* content);
void output_with_format_invalid(const char* code_type, const char* content);
void output_quote();
%}

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
digit          [0-9]

reserved_words {absolute}|{and}|{begin}|{break}|{case}|{const}|{continue}|{do}|{else}|{end}|{for}|{function}|{if}|{mod}|{nil}|{not}|{object}|{of}|{or}|{program}|{then}|{to}|{var}|{while}|{array}|{integer}|{double}|{write}|{writeln}|{string}|{float}|{read}
identifiers [a-zA-Z_][a-zA-Z0-9_]{0,14}
symbols :=|==|<=|>=|[\;\:\(\)\[\]\+\-\*\/\.\=\<\>]
real_num [+-]?({digit}+(\.{digit}+)?)|({digit}+(\.{digit}+)?)([eE][+-]?{digit}+)
real_num_sym {real_num}[ ]*[+-]
quoted_string \'([^\']|\'\'){0,28}\'

invalid_identifiers [a-zA-Z{digit}#]+
invalid_real_num [+-]?[0-9\.eE]+
invalid_real_num_sym {invalid_real_num}[+-]

invalid_string [a-zA-Z{digit}\'\"]+

space [ ]
eol \n
Other .

%x COMMENT
%%
"(*"                        { BEGIN(COMMENT); }
<COMMENT>"*)"               { BEGIN(INITIAL); }
<COMMENT>\n                 { lineCount++; }
<COMMENT>.                  { /* Ignore everything within comments except new lines */ }
"*)"						{ output_result("comment",1,1); }

{reserved_words}    { output_result("reserved word",0,0); }
{identifiers}       { output_result("ID",1,0); }
{symbols}           { output_result("symbol",0,0); }
{real_num}          { output_result("real number",0,0); }

{real_num_sym}          {
	char realPart[256] = {0};
    char symbolPart[2] = {0};
    int len = strlen(yytext);
    strncpy(realPart, yytext, len - 1);
    char noSpaceContent[strlen(realPart) + 1];
    int j = 0;
    for (int i = 0; realPart[i] != '\0'; i++) {
        if (realPart[i] != ' ') {
            noSpaceContent[j++] = realPart[i];
        }
    }
    noSpaceContent[j] = '\0';
	symbolPart[0] = yytext[len - 1];
	output_with_format("real number", noSpaceContent);
	charCount += strlen(realPart);
    output_with_format("symbol", symbolPart);
	charCount += strlen(symbolPart);
}
{quoted_string}					{ output_quote(); }
{invalid_identifiers}            { output_result("ID",1,1); }
{invalid_real_num}            { output_result("real number",1,1); }

{invalid_real_num_sym}          {
	char realPart[256] = {0};
    char symbolPart[2] = {0};
    int len = strlen(yytext);
    strncpy(realPart, yytext, len - 1);
    char noSpaceContent[strlen(realPart) + 1];
    int j = 0;
    for (int i = 0; realPart[i] != '\0'; i++) {
        if (realPart[i] != ' ') {
            noSpaceContent[j++] = realPart[i];
        }
    }
    noSpaceContent[j] = '\0';
	symbolPart[0] = yytext[len - 1];
	output_with_format_invalid("real number", noSpaceContent);
	charCount += strlen(realPart);
    output_with_format("symbol", symbolPart);
	charCount += strlen(symbolPart);
}

{invalid_string}            { output_result("string",1,1); }
{space}             { charCount += yyleng; }
{eol}               { lineCount++; charCount = 1; }
{Other}             { 
	if (yyleng > 1)
		output_result("OOOOOO", 0, 1); 
}

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
	charCount += yyleng;
}

void output_with_format(const char* code_type, const char* content)
{
	printf("Line: %d, 1st char: %d, \"%s\" is a \"%s\".\n",lineCount, charCount, content, code_type);
}

void output_with_format_invalid(const char* code_type, const char* content)
{
	printf("Line: %d, 1st char: %d, \"%s\" is an invalid \"%s\".\n",lineCount, charCount, content, code_type);
}

void output_quote() {
	char output[yyleng + 1]; // Allocate enough space for the output string
    int j = 0;
	if (yyleng> 2){
		for (int i = 0; i < yyleng; i++, j++) {
			if (yytext[i] == '\'' && yytext[i+1] == '\'') {
				output[j] = '\'';
				i++;
			} else {
				output[j] = yytext[i];
			}
		}
		output[j] = '\0';
		printf("Line: %d, 1st char: %d, \"%s\" is a \"%s\".\n",lineCount, charCount, output, "quoted string");
	}
	else{
		printf("Line: %d, 1st char: %d, \"%s\" is a \"%s\".\n",lineCount, charCount, yytext, "quoted string");

	}
	charCount += yyleng;
}