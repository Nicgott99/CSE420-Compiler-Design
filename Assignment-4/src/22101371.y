%{
#include <iostream>
#include <string>
#include "symbol_info.h"
#include "scope_table.h"
#include "symbol_table.h"
#include "three_addr_code.h"

using namespace std;

int line_count = 1;

void yyerror(const char* s);
int yylex();

%}

%union {
    symbol_info* info;
    char* str;
    int num;
}

%token <info> ID CONST_INT CONST_FLOAT
%token <str> ADDOP MULOP INCOP DECOP RELOP ASSIGNOP LOGICOP NOT
%token <str> IF ELSE FOR WHILE RETURN VOID INT FLOAT PRINTF COMMA SEMICOLON LPAREN RPAREN LBRACE RBRACE LSQB RSQB

%type <info> expression simple_expression term factor
%type <info> statement declaration function_definition program

%left LOGICOP OR
%left LOGICOP AND  
%left RELOP
%left ADDOP
%left MULOP
%precedence UNARY_MINUS UNARY_NOT

%%

program:
      /* empty */
    | program function_definition
    | program declaration SEMICOLON
;

function_definition:
    type_specifier ID LPAREN params RPAREN LBRACE compound_statement RBRACE
;

type_specifier:
    INT
    | FLOAT
    | VOID
;

params:
    /* empty */
    | ID
    | params COMMA ID
;

compound_statement:
    LBRACE statements RBRACE
;

statements:
    /* empty */
    | statements statement
;

statement:
    declaration SEMICOLON
    | expression SEMICOLON
    | compound_statement
    | IF LPAREN expression RPAREN statement
    | IF LPAREN expression RPAREN statement ELSE statement
    | WHILE LPAREN expression RPAREN statement
    | FOR LPAREN expression SEMICOLON expression SEMICOLON expression RPAREN statement
    | PRINTF LPAREN ID RPAREN SEMICOLON
    | RETURN expression SEMICOLON
;

declaration:
    type_specifier ID
    | type_specifier ID LSQB CONST_INT RSQB
;

expression:
    simple_expression
    | expression ASSIGNOP simple_expression
;

simple_expression:
    term
    | simple_expression ADDOP term
    | simple_expression RELOP term
    | simple_expression LOGICOP AND term
    | simple_expression LOGICOP OR term
;

term:
    factor
    | term MULOP factor
;

factor:
    CONST_INT
    | CONST_FLOAT
    | ID
    | ID LSQB expression RSQB
    | ID LPAREN arguments RPAREN
    | LPAREN expression RPAREN
    | ADDOP factor %prec UNARY_MINUS
    | NOT factor %prec UNARY_NOT
    | INCOP ID
    | DECOP ID
    | ID INCOP
    | ID DECOP
;

arguments:
    /* empty */
    | expression
    | arguments COMMA expression
;

%%

void yyerror(const char* s) {
    cerr << "Error at line " << line_count << ": " << s << endl;
}

int main() {
    yyparse();
    return 0;
}
