%{
#include <stdio.h>
#include <stdlib.h>
void yyerror(const char *s);

extern int yylex();
%}

%union {
    int num;
    char* str;
}

%token <str> IDENTIFIER
%token <num> NUMBER
%token PROGRAM VAR BEGIN END DO TO ARRAY OF INTEGER ASSIGN EQ LE GE FOR
%token PLUS MINUS MULT DIV MOD
%token LP RP

%type <str> variable_declaration
%type <num> expression type

%%
program:
    PROGRAM IDENTIFIER ';' declarations BEGIN statements END '.' { printf("Pascal program parsed successfully.\n"); }
    ;

declarations:
    VAR variable_declaration
    | /* Empty */
    ;

variable_declaration:
    IDENTIFIER ':' type ';' { printf("Declared variable: %s\n", $1); }
    ;

type:
    INTEGER { $$ = "integer"; }
    | ARRAY '[' NUMBER ".." NUMBER ']' OF INTEGER { $$ = "array of integer"; }
    ;

statements:
    statement
    | statements statement
    ;

statement:
    IDENTIFIER ASSIGN expression ';' { printf("Assignment to %s\n", $1); }
    | FOR IDENTIFIER ASSIGN expression TO expression DO BEGIN statements END ';' { printf("For loop\n"); }
    | /* Other statements */
    ;

expression:
    NUMBER
    | IDENTIFIER
    | expression PLUS expression
    | expression MINUS expression
    | expression MULT expression
    | expression DIV expression
    | expression MOD expression
    | LP expression RP
    ;

%%
void yyerror(const char *s) {
    fprintf(stderr, "Error: %s\n", s);
}

int main(void) {
    yyparse();
    return 0;
}