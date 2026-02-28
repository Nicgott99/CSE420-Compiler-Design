%{
#include <iostream>
#include <string>
#include "symbol_info.h"

using namespace std;

extern int line_count;
extern int yyparse();

%}

%%

"if"            { return IF; }
"else"          { return ELSE; }
"for"           { return FOR; }
"while"         { return WHILE; }
"return"        { return RETURN; }
"void"          { return VOID; }
"int"           { return INT; }
"float"         { return FLOAT; }
"printf"        { return PRINTF; }

"+"             { yylval.str = strdup("+"); return ADDOP; }
"-"             { yylval.str = strdup("-"); return ADDOP; }
"*"             { yylval.str = strdup("*"); return MULOP; }
"/"             { yylval.str = strdup("/"); return MULOP; }
"%"             { yylval.str = strdup("%"); return MULOP; }

"<"             { yylval.str = strdup("<"); return RELOP; }
">"             { yylval.str = strdup(">"); return RELOP; }
"=="            { yylval.str = strdup("=="); return RELOP; }
"!="            { yylval.str = strdup("!="); return RELOP; }
"<="            { yylval.str = strdup("<="); return RELOP; }
">="            { yylval.str = strdup(">="); return RELOP; }

"&&"            { yylval.str = strdup("&&"); return LOGICOP; }
"||"            { yylval.str = strdup("||"); return LOGICOP; }
"!"				{ yylval.str = strdup("!"); return NOT; }

"="             { return ASSIGNOP; }
"++"            { yylval.str = strdup("++"); return INCOP; }
"--"            { yylval.str = strdup("--"); return DECOP; }

"("             { return LPAREN; }
")"             { return RPAREN; }
"{"             { return LBRACE; }
"}"             { return RBRACE; }
"["             { return LSQB; }
"]"             { return RSQB; }
","             { return COMMA; }
";"             { return SEMICOLON; }

[0-9]+          {
                    yylval.info = new symbol_info(yytext, "CONST_INT");
                    return CONST_INT;
                }

[0-9]*\.[0-9]+  {
                    yylval.info = new symbol_info(yytext, "CONST_FLOAT");
                    return CONST_FLOAT;
                }

[a-zA-Z_][a-zA-Z0-9_]*  {
                    yylval.info = new symbol_info(yytext, "ID");
                    return ID;
                }

\n              { line_count++; }
[ \t\r]         { /* Ignore whitespace */ }
.               { /* Ignore unknown characters */ }

%%

int yywrap() {
    return 1;
}
