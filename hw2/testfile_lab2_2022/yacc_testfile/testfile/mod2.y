%{
#include <stdio.h>
#include <stdlib.h>
void yyerror(const char *s);
double ans = 0;
char msg[1024];
char temp[1024];
int flag = 1;
extern int lineNum;
extern int yylex();
%}

%union {
    int num;
    char* str;
}

%token <str> IDENTIFIER
%token <num> NUMBER
%token PROGRAM VAR BEGIM END DO TO ARRAY OF INTEGER ASSIGN EQ LE GE FOR
%token PLUS MINUS MULT DIV MOD COMMA
%token LP RP DOTDOT

%type <str> variable_declaration type identifier_list
%type <num> expression 

%%
program:
    PROGRAM IDENTIFIER ';' declarations BEGIM statements END '.' {
        printf("Pascal program parsed successfully.\n");
    }
    ;

declarations:
    VAR variable_declaration
    | declarations variable_declaration
    ;

variable_declaration:
    identifier_list ':' type ';' {
        printf("Line %d: Declared variables: %s as type %s\n", lineNum, $1, $3);
    }
    ;

identifier_list:
    IDENTIFIER {
        $$ = strdup($1);
    }
    | identifier_list COMMA IDENTIFIER {
        printf("hihi\n");
        char *list = malloc(strlen($1) + strlen($3) + 3);
        sprintf(list, "%s, %s", $1, $3);
        free($1); // Free the previously allocated string
        $$ = list;
    }
    ;

type:
    INTEGER { $$ = strdup("integer"); }
    | ARRAY '[' NUMBER DOTDOT NUMBER ']' OF INTEGER {
        char *type = malloc(128);
        sprintf(type, "array [%d .. %d] of integer", $3, $5);
        $$ = type;
    }
    ;

statements:
    statement
    | statements statement
    ;

statement:
    IDENTIFIER ASSIGN expression ';' {
        printf("Line %d: Assignment to %s\n", lineNum, $1);
    }
    | FOR IDENTIFIER ASSIGN expression TO expression DO BEGIM statements END ';' {
        printf("Line %d: For loop\n", lineNum);
    }
    ;

expression:
    NUMBER { $$ = $1; }
    | IDENTIFIER { $$ = 0; /* Typically would look up the identifier's value here */ }
    | expression PLUS expression { $$ = $1 + $3; }
    | expression MINUS expression { $$ = $1 - $3; }
    | expression MULT expression { $$ = $1 * $3; }
    | expression DIV expression { $$ = $1 / $3; }
    | expression MOD expression { $$ = $1 % $3; }
    | LP expression RP { $$ = $2; }
    ;

%%
void yyerror(const char *s) {
	  printf("line %d, error: %s\n", lineNum+1, s);
      flag = 0;
};

int main(void) {
    yyparse();
    return 0;
}