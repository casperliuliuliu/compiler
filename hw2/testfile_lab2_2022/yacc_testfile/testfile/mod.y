%{
    #include <stdio.h>
    #include <string.h>
    #include <math.h>
    #include "y.tab.h"
    extern int lineNum;
    int yylex();
    double ans = 0;
    void yyerror();
    char msg[1024];
    char temp[1024];
    int flag = 1;
%}

%union {
    float floatVal;
    int intVal;
    char* strVal;  // Assuming tokens like ID, SYMBOL might return strings
}

%type <floatVal> NUMBER 
%type <floatVal> expression term factor group
/* %type <strVal> reserved_statement IDENTIFIER_statement */

%token PLUS MINUS MUL DIV
%token LP RP
%token NUMBER NEWLINE
%token <strVal> RESERVE IDENTIFIER SYMBOL
%token PROGRAM VAR BEGIM END ASSIGN DECLARE
%token SEMICOLON DOT

%type <strVal> program_header variable_declaration statements statement

%%
program:
    program_header variable_declarations BEGIM statements END DOT {
        printf("Pascal program parsed successfully.\n");
    }
    ;

program_header:
    PROGRAM IDENTIFIER SEMICOLON opt_newlines {
        printf("Program Name: %s\n", $2);
    }
    ;

variable_declarations:
    VAR variable_declaration_list opt_newlines
    | /* Empty */
    ;

variable_declaration_list:
    variable_declaration 
    | variable_declaration_list NEWLINE variable_declaration
    ;

variable_declaration:
    IDENTIFIER DECLARE RESERVE SEMICOLON {
        printf("Declared variable %s with type %s\n", $1, $3);
    }
    | IDENTIFIER DECLARE NUMBER SEMICOLON {
        printf("Declared variable %s with initial value %f\n", $1, $3);
    }
    ;

statements:
    statement
    | statements statement
    | statements NEWLINE statement
    ;

statement:
    IDENTIFIER ASSIGN expression SEMICOLON {
        printf("Line %d: Assignment to %s, Result: %f\n", lineNum, $1, $3);
    }
    
    ;
/* lines :empty */
	/* | lines expression NEWLINE {printf("%lf\n", $2);}
	; */
opt_newlines:
    | NEWLINE
    | opt_newlines NEWLINE
    ;
    
expression: expression PLUS {strcat(msg, " + ");} term { $$ = $1 + $4; }
    | expression MINUS {strcat(msg, " - ");} term { $$ = $1 - $4; }
    |  term { $$ = $1; }
    ;

term: term MUL {strcat(msg, " * ");} factor { $$ = $1 * $4; }
    | term DIV {strcat(msg, " / ");} factor { $$ = $1 / $4; }
    | factor { $$ = $1; }
    | error NUMBER { /* Error happened, discard token until it find NUMBER. */
        yyerrok;     /* Error recovery. */
    }
    ;
factor: group { $$ = $1; }
    | NUMBER {
        $$ = $1;
        int d = (int)$1;
        sprintf(temp, "%d", d);
        strcat(msg, temp);
    }
    ;

group: LP {strcat(msg, " ( ");} expression RP { strcat(msg, " ) ");  $$ = $3; }
    ;

%%

int main(){
    yyparse();
    return 0;
}

void yyerror() {
	  printf("syntax error at line %d\n", lineNum+1);
      flag = 0;
};
