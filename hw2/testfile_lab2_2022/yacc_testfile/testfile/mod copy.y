%{
    #include <stdio.h>
    #include <string.h>
    #include <math.h>
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
%type <strVal> reserved_statement IDENTIFIER_statement

%token PLUS MINUS MUL DIV
%token LP RP
%token NUMBER NEWLINE
%token <strVal> RESERVE IDENTIFIER SYMBOL
%%
lines: /* empty (epsilon)*/ {printf("+++++++1\n");}
    | lines expression NEWLINE {
        if(flag == 1 && strlen(msg) > 0){
            printf("=line %d: %s\t (ans = %lf)\n", lineNum, msg , $2 );
            memset(msg, 0, 256);
      }
      else{
          flag = 1;
          memset(msg, 0, 256);
      }
    }
    /* | lines statement NEWLINE { printf("44\n"); } */
    | lines reserved_statement NEWLINE {
    if(flag == 1 && (strlen(msg) > 0 || strlen($2) >)){
            printf("=line %d: %s\n", lineNum, msg , $2 );
            memset(msg, 0, 256);
      }
      else{
          flag = 1;
          memset(msg, 0, 256);
      }
      }
    | lines IDENTIFIER_statement NEWLINE { 
    if(flag == 1 && strlen(msg) > 0 ){
            printf("=line %d: %s\n", lineNum, msg , $2 );
            memset(msg, 0, 256);
      }
      else{
          flag = 1;
          memset(msg, 0, 256);
      }}
    | lines NEWLINE {
        printf("empty linee!\n");
    }
    ;

reserved_statement: 
/* ans: array[0 .. 81] of integer; */
  /* i, j: integer; */

    reserved_statement IDENTIFIER_statement SYMBOL { printf("cc1\n"); sprintf(msg + strlen(msg), "%s %s %s ", $1,$2,$3); }
    | IDENTIFIER_statement reserved_statement SYMBOL { printf("cc2\n"); sprintf(msg + strlen(msg), "%s ", $3); }
    | RESERVE SYMBOL { printf("cc3\n"); sprintf(msg + strlen(msg), "%s %s ", $1,$2); }
    | SYMBOL RESERVE { printf("cc4\n"); sprintf(msg + strlen(msg), "%s %s ", $1,$2); }
    | RESERVE { printf("cc5\n"); $$ = $1;/*sprintf(msg + strlen(msg), "%s ", $1);*/ }
    | IDENTIFIER_statement reserved_statement SYMBOL factor SYMBOL SYMBOL factor SYMBOL reserved_statement{printf("cc8\n"); sprintf(msg + strlen(msg), "%s %lf %s %s %lf %s", $3,$4,$5,$6,$7,$8); }
    | error RESERVE {  printf("cc7\n"); strcat(msg, $2); strcat(msg, " "); }
    | reserved_statement RESERVE { printf("cc8\n"); strcat(msg, $1); strcat(msg, " "); strcat(msg, $2); strcat(msg, " "); }
    ;

IDENTIFIER_statement:
    IDENTIFIER_statement IDENTIFIER { printf("id1\n"); $$ = $1; strcat(msg, $2); strcat(msg, " "); }
    | IDENTIFIER_statement SYMBOL { printf("id2\n"); $$ = $1; strcat(msg, $2); strcat(msg, " "); }
    | IDENTIFIER { printf("id3\n"); $$ = $1;}
    ;

expression: expression PLUS {strcat(msg, " + ");} term { $$ = $1 + $4; }
    | expression MINUS {strcat(msg, " - ");} term { $$ = $1 - $4; }
    |  term { $$ = $1; }
    ;

term: term MUL {strcat(msg, " * ");} factor { $$ = $1 * $4; }
    | term DIV {strcat(msg, " / ");} factor { $$ = $1 / $4; }
    | factor { $$ = $1; }
    /* | error NUMBER { /* Error happened, discard token until it find NUMBER. */
        /*yyerrok;     /* Error recovery. */
    /*} */
    ;
factor: group { $$ = $1; }
    | NUMBER {
        printf("fa1\n");
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
