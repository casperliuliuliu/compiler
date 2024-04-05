%{
#include <stdio.h>
%}

%%
"program"|"Program"|"PROGRAM"   { printf("Reserved word: %s\n", yytext); }
[abcdefghijklmnopqrstuvwxyzABCDEFGHIJKLMNOPQRSTUVWXYZ_][abcdefghijklmnopqrstuvwxyzABCDEFGHIJKLMNOPQRSTUVWXYZ0123456789_]{0,14}    { printf("Identifier: %s\n", yytext); }
"+"|"-"|"*"|"/"|"="|"<"|">"|"("|")"|"["|"]"|"{"|"}"|"."|";"|":"    { printf("Symbol: %s\n", yytext); }
[0-9]+     { printf("Integer: %s\n", yytext); }
[0-9]+"."[0-9]+    { printf("Real: %s\n", yytext); }
\"(\\.|[^\\"])*\"   { printf("Quoted string: %s\n", yytext); }
{some_regex_for_comments}    { /* Skip comments */ }
.   { printf("Error: Unknown token %s\n", yytext); }

%%

int yywrap() { return 1; }
int main() {
    yylex();
    return 0;
}
