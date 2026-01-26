/*
 * CSE420 Assignment 2 - Lexical Analyzer
 * Student ID: 22101371
 * 
 * This file implements a lexical analyzer using Flex for a C-like programming language.
 * It recognizes keywords, operators, identifiers, constants, and other tokens.
 */

%option noyywrap

%{
#include "symbol_info.h"

#define YYSTYPE symbol_info*

#include "y.tab.h"

extern YYSTYPE yylval;
void yyerror(char *);
extern int lines;
%}

/* Regular Expression Definitions */
delim	 [ \t\v\r\f]
newline  \r?\n
ws		 {delim}+
letter_	 [A-Za-z_]
digit	 [0-9]
id		 {letter_}({letter_}|{digit})*
integers {digit}+
floats	 {digit}*(\.{digit}+)|{digit}*(\.{digit}+)?((E|e)[-]?{digit}+)

%%

/* Whitespace and Newlines */
{ws}		{ /* ignore whitespace */ }
{newline}	{ lines++; }

/* Keywords */
if          { return IF; }
else		{ return ELSE; }
for         { return FOR; }
while       { return WHILE; }
do          { return DO; }
break       { return BREAK; }
continue    { return CONTINUE; }
return      { return RETURN; }
int         { return INT; }
float       { return FLOAT; }
char        { return CHAR; }
void        { return VOID; }
double      { return DOUBLE; }
switch      { return SWITCH; }
case        { return CASE; }
default     { return DEFAULT; }
printf      { return PRINTLN; }

/* Arithmetic Operators */
"+"|"-"	    {
                symbol_info *s = new symbol_info((string)yytext,"ADDOP");
                yylval = (YYSTYPE)s;
                return ADDOP;
		    }
"*"|"/"|"%"    {
                symbol_info *s = new symbol_info((string)yytext,"MULOP");
                yylval = (YYSTYPE)s;
                return MULOP;
            }

/* Increment/Decrement Operators */
"++"        { return INCOP; }
"--"        { return DECOP; }

/* Relational Operators */
"<"|">"|"<="|">="|"=="|"!=" {
                symbol_info *s = new symbol_info((string)yytext,"RELOP");
                yylval = (YYSTYPE)s;
                return RELOP;
            }

/* Assignment Operator */
"="         { return ASSIGNOP; } 

/* Logical Operators */
"&&"|"||"   {
		   	symbol_info *s = new symbol_info((string)yytext,"LOGICOP");
			yylval = (YYSTYPE)s;
			return LOGICOP;
		    }

/* Unary NOT Operator */
"!"        { return NOT; }

/* Delimiters */
"("        { return LPAREN; }
")"        { return RPAREN; }
"{"        { return LCURL; }
"}"        { return RCURL; }
"["        { return LTHIRD; }
"]"        { return RTHIRD; }
";"        { return SEMICOLON; }
","        { return COMMA; }

/* Identifiers */
{id}       {
                symbol_info *s = new symbol_info((string)yytext,"ID");
                yylval = (YYSTYPE)s;
                return ID;
            }

/* Integer Constants */
{integers} {
                symbol_info *s = new symbol_info((string)yytext,"INT");
                yylval = (YYSTYPE)s;
                return CONST_INT;
            }

/* Floating Point Constants */
{floats}   {
                symbol_info *s = new symbol_info((string)yytext,"FLOAT");
                yylval = (YYSTYPE)s;
                return CONST_FLOAT;
            }

/* Error Handling */
.          {
                printf("Unrecognized character: %c at line %d\n", yytext[0], lines);
            }

%%

/*
 * Additional C Code Section
 * This section can contain helper functions and additional code
 * that will be copied directly to the generated lexer.
 */