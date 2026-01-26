/*
 * CSE420 Assignment 2 - Syntax Analyzer
 * Student ID: 22101371
 * 
 * This file implements a syntax analyzer using Bison for a C-like programming language.
 * It defines the grammar rules and semantic actions for parsing C-like source code.
 */

%{
#include "symbol_table.h"

#define YYSTYPE symbol_info*

extern FILE *yyin;
int yyparse(void);
int yylex(void);
extern YYSTYPE yylval;

// Global symbol table - manages all scopes and symbols
// You can store the pointer to your symbol table in a global variable
// or you can create an object

int lines = 1;            // Line counter for error reporting
ofstream outlog;          // Output log file for parse tree and symbol table

// Additional variables for storing necessary info
// such as current variable type, variable list, function name, return type, 
// function parameter types, parameters names etc.

/**
 * @brief Error handler for syntax errors
 * @param s Error message string
 */
void yyerror(char *s)
{
	outlog << "At line " << lines << " " << s << endl << endl;
    // you may need to reinitialize variables if you find an error
}
%}

/* Token Declarations */
%token IF ELSE FOR WHILE DO BREAK INT CHAR FLOAT DOUBLE VOID RETURN SWITCH CASE DEFAULT CONTINUE PRINTLN
%token ADDOP MULOP INCOP DECOP RELOP ASSIGNOP LOGICOP NOT
%token LPAREN RPAREN LCURL RCURL LTHIRD RTHIRD COMMA SEMICOLON
%token CONST_INT CONST_FLOAT ID

/* Precedence and Associativity */
%nonassoc LOWER_THAN_ELSE
%nonassoc ELSE

%%

/* Grammar Rules and Semantic Actions */

start : program
	{
		outlog << "At line no: " << lines << " start : program " << endl << endl;
		outlog << "Symbol Table" << endl << endl;
		
		// Print your whole symbol table here
	}
	;

program : program unit
	{
		outlog << "At line no: " << lines << " program : program unit " << endl << endl;
		outlog << $1->get_name() + "\n" + $2->get_name() << endl << endl;
		
		$$ = new symbol_info($1->get_name() + "\n" + $2->get_name(), "program");
	}
	| unit
	{
		outlog << "At line no: " << lines << " program : unit " << endl << endl;
		outlog << $1->get_name() << endl << endl;
		
		$$ = new symbol_info($1->get_name(), "program");
	}
	;

unit : var_declaration
	 {
		outlog << "At line no: " << lines << " unit : var_declaration " << endl << endl;
		outlog << $1->get_name() << endl << endl;
		
		$$ = new symbol_info($1->get_name(), "unit");
	 }
     | func_definition
     {
		outlog << "At line no: " << lines << " unit : func_definition " << endl << endl;
		outlog << $1->get_name() << endl << endl;
		
		$$ = new symbol_info($1->get_name(), "unit");
	 }
     ;

func_definition : type_specifier ID LPAREN parameter_list RPAREN compound_statement
		{	
			outlog << "At line no: " << lines << " func_definition : type_specifier ID LPAREN parameter_list RPAREN compound_statement " << endl << endl;
			outlog << $1->get_name() << " " << $2->get_name() << "(" + $4->get_name() + ")\n" << $6->get_name() << endl << endl;
			
			$$ = new symbol_info($1->get_name() + " " + $2->get_name() + "(" + $4->get_name() + ")\n" + $6->get_name(), "func_def");	
			
			// The function definition is complete.
            // You can now insert necessary information about the function into the symbol table
            // However, note that the scope of the function and the scope of the compound statement are different.
		}
		| type_specifier ID LPAREN RPAREN compound_statement
		{
			outlog << "At line no: " << lines << " func_definition : type_specifier ID LPAREN RPAREN compound_statement " << endl << endl;
			outlog << $1->get_name() << " " << $2->get_name() << "()\n" << $5->get_name() << endl << endl;
			
			$$ = new symbol_info($1->get_name() + " " + $2->get_name() + "()\n" + $5->get_name(), "func_def");	
			
			// The function definition is complete.
            // You can now insert necessary information about the function into the symbol table
            // However, note that the scope of the function and the scope of the compound statement are different.
		}
 		;

parameter_list : parameter_list COMMA type_specifier ID
		{
			outlog << "At line no: " << lines << " parameter_list : parameter_list COMMA type_specifier ID " << endl << endl;
			outlog << $1->get_name() << "," << $3->get_name() << " " << $4->get_name() << endl << endl;
					
			$$ = new symbol_info($1->get_name() + "," + $3->get_name() + " " + $4->get_name(), "param_list");
			
            // store the necessary information about the function parameters
            // They will be needed when you want to enter the function into the symbol table
		}
		| parameter_list COMMA type_specifier
		{
			outlog << "At line no: " << lines << " parameter_list : parameter_list COMMA type_specifier " << endl << endl;
			outlog << $1->get_name() << "," << $3->get_name() << endl << endl;
			
			$$ = new symbol_info($1->get_name() + "," + $3->get_name(), "param_list");
			
            // store the necessary information about the function parameters
            // They will be needed when you want to enter the function into the symbol table
		}
 		| type_specifier ID
 		{
			outlog << "At line no: " << lines << " parameter_list : type_specifier ID " << endl << endl;
			outlog << $1->get_name() << " " << $2->get_name() << endl << endl;
			
			$$ = new symbol_info($1->get_name() + " " + $2->get_name(), "param_list");
			
            // store the necessary information about the function parameters
            // They will be needed when you want to enter the function into the symbol table
		}
		| type_specifier
		{
			outlog << "At line no: " << lines << " parameter_list : type_specifier " << endl << endl;
			outlog << $1->get_name() << endl << endl;
			
			$$ = new symbol_info($1->get_name(), "param_list");
			
            // store the necessary information about the function parameters
            // They will be needed when you want to enter the function into the symbol table
		}
 		;

compound_statement : LCURL statements RCURL
			{ 
 		    	outlog << "At line no: " << lines << " compound_statement : LCURL statements RCURL " << endl << endl;
				outlog << "{\n" + $2->get_name() + "\n}" << endl << endl;
				
				$$ = new symbol_info("{\n" + $2->get_name() + "\n}", "comp_stmnt");
				
                // The compound statement is complete.
                // Print the symbol table here and exit the scope
                // Note that function parameters should be in the current scope
 		    }
 		    | LCURL RCURL
 		    { 
 		    	outlog << "At line no: " << lines << " compound_statement : LCURL RCURL " << endl << endl;
				outlog << "{\n}" << endl << endl;
				
				$$ = new symbol_info("{\n}", "comp_stmnt");
				
				// The compound statement is complete.
                // Print the symbol table here and exit the scope
 		    }
 		    ;
 		    
var_declaration : type_specifier declaration_list SEMICOLON
		 {
			outlog << "At line no: " << lines << " var_declaration : type_specifier declaration_list SEMICOLON " << endl << endl;
			outlog << $1->get_name() << " " << $2->get_name() << ";" << endl << endl;
			
			$$ = new symbol_info($1->get_name() + " " + $2->get_name() + ";", "var_dec");
			
			// Insert necessary information about the variables in the symbol table
		 }
 		 ;

type_specifier : INT
		{
			outlog << "At line no: " << lines << " type_specifier : INT " << endl << endl;
			outlog << "int" << endl << endl;
			
			$$ = new symbol_info("int", "type");
	    }
 		| FLOAT
 		{
			outlog << "At line no: " << lines << " type_specifier : FLOAT " << endl << endl;
			outlog << "float" << endl << endl;
			
			$$ = new symbol_info("float", "type");
	    }
 		| VOID
 		{
			outlog << "At line no: " << lines << " type_specifier : VOID " << endl << endl;
			outlog << "void" << endl << endl;
			
			$$ = new symbol_info("void", "type");
	    }
 		;

declaration_list : declaration_list COMMA ID
		  {
 		  	outlog << "At line no: " << lines << " declaration_list : declaration_list COMMA ID " << endl << endl;
 		  	outlog << $1->get_name() + "," << $3->get_name() << endl << endl;

            // you may need to store the variable names to insert them in symbol table here or later
			$$ = new symbol_info($1->get_name() + "," + $3->get_name(), "dec_list");
 		  }
 		  | declaration_list COMMA ID LTHIRD CONST_INT RTHIRD
 		  {
 		  	outlog << "At line no: " << lines << " declaration_list : declaration_list COMMA ID LTHIRD CONST_INT RTHIRD " << endl << endl;
 		  	outlog << $1->get_name() + "," << $3->get_name() << "[" << $5->get_name() << "]" << endl << endl;

            // you may need to store the variable names to insert them in symbol table here or later
			$$ = new symbol_info($1->get_name() + "," + $3->get_name() + "[" + $5->get_name() + "]", "dec_list");
 		  }
 		  |ID
 		  {
 		  	outlog << "At line no: " << lines << " declaration_list : ID " << endl << endl;
			outlog << $1->get_name() << endl << endl;

            // you may need to store the variable names to insert them in symbol table here or later
			$$ = new symbol_info($1->get_name(), "dec_list");
 		  }
 		  | ID LTHIRD CONST_INT RTHIRD
 		  {
 		  	outlog << "At line no: " << lines << " declaration_list : ID LTHIRD CONST_INT RTHIRD " << endl << endl;
			outlog << $1->get_name() << "[" << $3->get_name() << "]" << endl << endl;

            // you may need to store the variable names to insert them in symbol table here or later
            $$ = new symbol_info($1->get_name() + "[" + $3->get_name() + "]", "dec_list");
 		  }
 		  ;

statements : statement
	   {
	    	outlog << "At line no: " << lines << " statements : statement " << endl << endl;
			outlog << $1->get_name() << endl << endl;
			
			$$ = new symbol_info($1->get_name(), "stmnts");
	   }
	   | statements statement
	   {
	    	outlog << "At line no: " << lines << " statements : statements statement " << endl << endl;
			outlog << $1->get_name() << "\n" << $2->get_name() << endl << endl;
			
			$$ = new symbol_info($1->get_name() + "\n" + $2->get_name(), "stmnts");
	   }
	   ;

statement : var_declaration
	  {
	    	outlog << "At line no: " << lines << " statement : var_declaration " << endl << endl;
			outlog << $1->get_name() << endl << endl;
			
			$$ = new symbol_info($1->get_name(), "stmnt");
	  }
	  | func_definition
	  {
	  		outlog << "At line no: " << lines << " statement : func_definition " << endl << endl;
            outlog << $1->get_name() << endl << endl;

            $$ = new symbol_info($1->get_name(), "stmnt");
	  }
	  | expression_statement
	  {
	    	outlog << "At line no: " << lines << " statement : expression_statement " << endl << endl;
			outlog << $1->get_name() << endl << endl;
			
			$$ = new symbol_info($1->get_name(), "stmnt");
	  }
	  | compound_statement
	  {
	    	outlog << "At line no: " << lines << " statement : compound_statement " << endl << endl;
			outlog << $1->get_name() << endl << endl;
			
			$$ = new symbol_info($1->get_name(), "stmnt");
	  }
	  | FOR LPAREN expression_statement expression_statement expression RPAREN statement
	  {
	    	outlog << "At line no: " << lines << " statement : FOR LPAREN expression_statement expression_statement expression RPAREN statement " << endl << endl;
			outlog << "for(" << $3->get_name() << $4->get_name() << $5->get_name() << ")\n" << $7->get_name() << endl << endl;
			
			$$ = new symbol_info("for(" + $3->get_name() + $4->get_name() + $5->get_name() + ")\n" + $7->get_name(), "stmnt");
	  }
	  | IF LPAREN expression RPAREN statement %prec LOWER_THAN_ELSE
	  {
	    	outlog << "At line no: " << lines << " statement : IF LPAREN expression RPAREN statement " << endl << endl;
			outlog << "if(" << $3->get_name() << ")\n" << $5->get_name() << endl << endl;
			
			$$ = new symbol_info("if(" + $3->get_name() + ")\n" + $5->get_name(), "stmnt");
	  }
	  | IF LPAREN expression RPAREN statement ELSE statement
	  {
	    	outlog << "At line no: " << lines << " statement : IF LPAREN expression RPAREN statement ELSE statement " << endl << endl;
			outlog << "if(" << $3->get_name() << ")\n" << $5->get_name() << "\nelse\n" << $7->get_name() << endl << endl;
			
			$$ = new symbol_info("if(" + $3->get_name() + ")\n" + $5->get_name() + "\nelse\n" + $7->get_name(), "stmnt");
	  }
	  | WHILE LPAREN expression RPAREN statement
	  {
	    	outlog << "At line no: " << lines << " statement : WHILE LPAREN expression RPAREN statement " << endl << endl;
			outlog << "while(" << $3->get_name() << ")\n" << $5->get_name() << endl << endl;
			
			$$ = new symbol_info("while(" + $3->get_name() + ")\n" + $5->get_name(), "stmnt");
	  }
	  | PRINTLN LPAREN ID RPAREN SEMICOLON
	  {
	    	outlog << "At line no: " << lines << " statement : PRINTLN LPAREN ID RPAREN SEMICOLON " << endl << endl;
			outlog << "printf(" << $3->get_name() << ");" << endl << endl; 
			
			$$ = new symbol_info("printf(" + $3->get_name() + ");", "stmnt");
	  }
	  | RETURN expression SEMICOLON
	  {
	    	outlog << "At line no: " << lines << " statement : RETURN expression SEMICOLON " << endl << endl;
			outlog << "return " << $2->get_name() << ";" << endl << endl;
			
			$$ = new symbol_info("return " + $2->get_name() + ";", "stmnt");
	  }
	  ;

expression_statement : SEMICOLON
			{
				outlog << "At line no: " << lines << " expression_statement : SEMICOLON " << endl << endl;
				outlog << ";" << endl << endl;
				
				$$ = new symbol_info(";", "expr_stmt");
	        }			
			| expression SEMICOLON 
			{
				outlog << "At line no: " << lines << " expression_statement : expression SEMICOLON " << endl << endl;
				outlog << $1->get_name() << ";" << endl << endl;
				
				$$ = new symbol_info($1->get_name() + ";", "expr_stmt");
	        }
			;

variable : ID 	
      {
	    outlog << "At line no: " << lines << " variable : ID " << endl << endl;
		outlog << $1->get_name() << endl << endl;
			
		$$ = new symbol_info($1->get_name(), "varbl");
	 }	
	 | ID LTHIRD expression RTHIRD 
	 {
	 	outlog << "At line no: " << lines << " variable : ID LTHIRD expression RTHIRD " << endl << endl;
		outlog << $1->get_name() << "[" << $3->get_name() << "]" << endl << endl;
		
		$$ = new symbol_info($1->get_name() + "[" + $3->get_name() + "]", "varbl");
	 }
	 ;

expression : logic_expression
	   {
	    	outlog << "At line no: " << lines << " expression : logic_expression " << endl << endl;
			outlog << $1->get_name() << endl << endl;
			
			$$ = new symbol_info($1->get_name(), "expr");
	   }
	   | variable ASSIGNOP logic_expression 	
	   {
	    	outlog << "At line no: " << lines << " expression : variable ASSIGNOP logic_expression " << endl << endl;
			outlog << $1->get_name() << "=" << $3->get_name() << endl << endl;

			$$ = new symbol_info($1->get_name() + "=" + $3->get_name(), "expr");
	   }
	   ;

logic_expression : rel_expression
	     {
	    	outlog << "At line no: " << lines << " logic_expression : rel_expression " << endl << endl;
			outlog << $1->get_name() << endl << endl;
			
			$$ = new symbol_info($1->get_name(), "lgc_expr");
	     }	
		 | rel_expression LOGICOP rel_expression 
		 {
	    	outlog << "At line no: " << lines << " logic_expression : rel_expression LOGICOP rel_expression " << endl << endl;
			outlog << $1->get_name() << $2->get_name() << $3->get_name() << endl << endl;
			
			$$ = new symbol_info($1->get_name() + $2->get_name() + $3->get_name(), "lgc_expr");
	     }	
		 ;

rel_expression	: simple_expression
		{
	    	outlog << "At line no: " << lines << " rel_expression : simple_expression " << endl << endl;
			outlog << $1->get_name() << endl << endl;
			
			$$ = new symbol_info($1->get_name(), "rel_expr");
	    }
		| simple_expression RELOP simple_expression
		{
	    	outlog << "At line no: " << lines << " rel_expression : simple_expression RELOP simple_expression " << endl << endl;
			outlog << $1->get_name() << $2->get_name() << $3->get_name() << endl << endl;
			
			$$ = new symbol_info($1->get_name() + $2->get_name() + $3->get_name(), "rel_expr");
	    }
		;

simple_expression : term
          {
	    	outlog << "At line no: " << lines << " simple_expression : term " << endl << endl;
			outlog << $1->get_name() << endl << endl;
			
			$$ = new symbol_info($1->get_name(), "simp_expr");
	      }
		  | simple_expression ADDOP term 
		  {
	    	outlog << "At line no: " << lines << " simple_expression : simple_expression ADDOP term " << endl << endl;
			outlog << $1->get_name() << $2->get_name() << $3->get_name() << endl << endl;
			
			$$ = new symbol_info($1->get_name() + $2->get_name() + $3->get_name(), "simp_expr");
	      }
		  ;

term :	unary_expression
     {
	    	outlog << "At line no: " << lines << " term : unary_expression " << endl << endl;
			outlog << $1->get_name() << endl << endl;
			
			$$ = new symbol_info($1->get_name(), "term");
	 }
     |  term MULOP unary_expression
     {
	    	outlog << "At line no: " << lines << " term : term MULOP unary_expression " << endl << endl;
			outlog << $1->get_name() << $2->get_name() << $3->get_name() << endl << endl;
			
			$$ = new symbol_info($1->get_name() + $2->get_name() + $3->get_name(), "term");
	 }
     ;

unary_expression : ADDOP unary_expression
		 {
	    	outlog << "At line no: " << lines << " unary_expression : ADDOP unary_expression " << endl << endl;
			outlog << $1->get_name() << $2->get_name() << endl << endl;
			
			$$ = new symbol_info($1->get_name() + $2->get_name(), "un_expr");
	     }
		 | NOT unary_expression 
		 {
	    	outlog << "At line no: " << lines << " unary_expression : NOT unary_expression " << endl << endl;
			outlog << "!" << $2->get_name() << endl << endl;
			
			$$ = new symbol_info("!" + $2->get_name(), "un_expr");
	     }
		 | factor 
		 {
	    	outlog << "At line no: " << lines << " unary_expression : factor " << endl << endl;
			outlog << $1->get_name() << endl << endl;
			
			$$ = new symbol_info($1->get_name(), "un_expr");
	     }
		 ;

factor	: variable
    {
	    outlog << "At line no: " << lines << " factor : variable " << endl << endl;
		outlog << $1->get_name() << endl << endl;
			
		$$ = new symbol_info($1->get_name(), "fctr");
	}
	| ID LPAREN argument_list RPAREN
	{
	    outlog << "At line no: " << lines << " factor : ID LPAREN argument_list RPAREN " << endl << endl;
		outlog << $1->get_name() << "(" << $3->get_name() << ")" << endl << endl;

		$$ = new symbol_info($1->get_name() + "(" + $3->get_name() + ")", "fctr");
	}
	| LPAREN expression RPAREN
	{
	   	outlog << "At line no: " << lines << " factor : LPAREN expression RPAREN " << endl << endl;
		outlog << "(" << $2->get_name() << ")" << endl << endl;
		
		$$ = new symbol_info("(" + $2->get_name() + ")", "fctr");
	}
	| CONST_INT 
	{
	    outlog << "At line no: " << lines << " factor : CONST_INT " << endl << endl;
		outlog << $1->get_name() << endl << endl;
			
		$$ = new symbol_info($1->get_name(), "fctr");
	}
	| CONST_FLOAT
	{
	    outlog << "At line no: " << lines << " factor : CONST_FLOAT " << endl << endl;
		outlog << $1->get_name() << endl << endl;
			
		$$ = new symbol_info($1->get_name(), "fctr");
	}
	| variable INCOP 
	{
	    outlog << "At line no: " << lines << " factor : variable INCOP " << endl << endl;
		outlog << $1->get_name() << "++" << endl << endl;
			
		$$ = new symbol_info($1->get_name() + "++", "fctr");
	}
	| variable DECOP
	{
	    outlog << "At line no: " << lines << " factor : variable DECOP " << endl << endl;
		outlog << $1->get_name() << "--" << endl << endl;
			
		$$ = new symbol_info($1->get_name() + "--", "fctr");
	}
	;

argument_list : arguments
			  {
					outlog << "At line no: " << lines << " argument_list : arguments " << endl << endl;
					outlog << $1->get_name() << endl << endl;
						
					$$ = new symbol_info($1->get_name(), "arg_list");
			  }
			  |
			  {
					outlog << "At line no: " << lines << " argument_list :  " << endl << endl;
					outlog << "" << endl << endl;
						
					$$ = new symbol_info("", "arg_list");
			  }
			  ;

arguments : arguments COMMA logic_expression
		  {
				outlog << "At line no: " << lines << " arguments : arguments COMMA logic_expression " << endl << endl;
				outlog << $1->get_name() << "," << $3->get_name() << endl << endl;
						
				$$ = new symbol_info($1->get_name() + "," + $3->get_name(), "arg");
		  }
	      | logic_expression
	      {
				outlog << "At line no: " << lines << " arguments : logic_expression " << endl << endl;
				outlog << $1->get_name() << endl << endl;
						
				$$ = new symbol_info($1->get_name(), "arg");
		  }
	      ;

%%

/**
 * @brief Main function - entry point for the compiler
 * @param argc Argument count
 * @param argv Argument vector
 * @return Exit status
 */
int main(int argc, char *argv[])
{
	if(argc != 2) 
	{
		cout << "Please input file name" << endl;
		return 0;
	}
	
	yyin = fopen(argv[1], "r");
	outlog.open("my_log.txt", ios::trunc);
	
	if(yyin == NULL)
	{
		cout << "Couldn't open file" << endl;
		return 0;
	}
	
	// Enter the global or the first scope here
	
	yyparse();
	
	outlog << endl << "Total lines: " << lines << endl;
	
	outlog.close();
	fclose(yyin);
	
	return 0;
}