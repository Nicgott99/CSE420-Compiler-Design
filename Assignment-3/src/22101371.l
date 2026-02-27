%option noyywrap

%{

#include"symbol_info.h"

#define YYSTYPE symbol_info*

#include "y.tab.h"

extern YYSTYPE yylval;

void yyerror(char *);

extern int line_counter;

%}

ws		 [ \t\v\r\f]+
newline  \r?\n
alpha_	 [A-Za-z_]
num	     [0-9]
identifier {alpha_}({alpha_}|{num})*
int_const  {num}+
float_const {num}*(\.{num}+)|{num}*(\.{num}+)?((E|e)[-]?{num}+)

%%

{ws}		{ }
{newline}	{ line_counter++; }

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

"+"|"-"	    {
                symbol_info *sym = new symbol_info((string)yytext,"ADDOP");
                yylval = (YYSTYPE)sym;
                return ADDOP;
		    }
"*"|"/"|"%"    {
                symbol_info *sym = new symbol_info((string)yytext,"MULOP");
                yylval = (YYSTYPE)sym;
                return MULOP;
            }
"++"        { return INCOP; }
"--"        { return DECOP; }
"<"|">"|"<="|">="|"=="|"!=" {
                symbol_info *sym = new symbol_info((string)yytext,"RELOP");
                yylval = (YYSTYPE)sym;
                return RELOP;
            }

"="         { return ASSIGNOP; }
"&&"|"||"   {
		   	symbol_info *sym = new symbol_info((string)yytext,"LOGICOP");
			yylval = (YYSTYPE)sym;
			return LOGICOP;
		    }

"!"        { return NOT; }
"("        { return LPAREN; }
")"        { return RPAREN; }
"{"        { return LCURL; }
"}"        { return RCURL; }
"["        { return LTHIRD; }
"]"        { return RTHIRD; }
";"        { return SEMICOLON; }
","        { return COMMA; }

{identifier} {
                symbol_info *sym = new symbol_info((string)yytext,"ID");
                yylval = (YYSTYPE)sym;
                return ID;
            }
{int_const} {
                symbol_info *sym = new symbol_info((string)yytext,"INT");
                yylval = (YYSTYPE)sym;
                return CONST_INT;
            }
{float_const} {
                symbol_info *sym = new symbol_info((string)yytext,"FLOAT");
                yylval = (YYSTYPE)sym;
                return CONST_FLOAT;
            }

%%