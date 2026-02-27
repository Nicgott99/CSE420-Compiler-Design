%{

#include"symbol_info.h"
#include "symbol_table.h"

#define YYSTYPE symbol_info*

int yyparse(void);
int yylex(void);

extern FILE *yyin;
extern YYSTYPE yylval;

ofstream log_stream;
ofstream err_stream;

int line_counter = 1;
int total_errors = 0;

symbol_table sym_tbl(10, &log_stream);
vector<symbol_info *> func_args;
int arg_counter = 0;
string active_function = "";
string expected_ret_type = "";

void yyerror(char *s)
{
	err_stream << "Line " << line_counter << " syntax error: " << s << "\n\n";
    total_errors++;
}

%}

%token IF ELSE FOR WHILE DO BREAK INT CHAR FLOAT DOUBLE VOID RETURN SWITCH CASE DEFAULT CONTINUE PRINTLN ADDOP MULOP INCOP DECOP RELOP ASSIGNOP LOGICOP NOT LPAREN RPAREN LCURL RCURL LTHIRD RTHIRD COMMA SEMICOLON CONST_INT CONST_FLOAT ID

%nonassoc LOWER_THAN_ELSE
%nonassoc ELSE

%%

start : program
	{
		log_stream<<"At line no: "<<line_counter<<" start : program\n\n";
		log_stream<<"Symbol Table\n\n";
		sym_tbl.print_all_scopes();
	}
	;

program : program unit
	{
		log_stream<<"At line no: "<<line_counter<<" program : program unit\n\n";
		log_stream<<$1->getname()+"\n"+$2->getname()<<"\n\n";
		$$ = new symbol_info($1->getname()+"\n"+$2->getname(),"program");
	}
	| unit
	{
		log_stream<<"At line no: "<<line_counter<<" program : unit\n\n";
		log_stream<<$1->getname()<<"\n\n";
		$$ = new symbol_info($1->getname(),"program");
	}
	;

unit : var_declaration
	{
		log_stream<<"At line no: "<<line_counter<<" unit : var_declaration\n\n";
		log_stream<<$1->getname()<<"\n\n";
		$$ = new symbol_info($1->getname(),"unit");
	}
	| func_definition
	{
		log_stream<<"At line no: "<<line_counter<<" unit : func_definition\n\n";
		log_stream<<$1->getname()<<"\n\n";
		$$ = new symbol_info($1->getname(),"unit");
	}
	;

func_definition : type_specifier ID LPAREN parameter_list RPAREN 
	{
        symbol_info* existing_sym = sym_tbl.lookup(new symbol_info($2->getname(), "ID"));
        if (existing_sym != nullptr) {
            err_stream << "At line no: " << line_counter << " Multiple declaration of function " << $2->getname() << "\n\n";
            total_errors++;
        } else {
            $2->set_symbol_type("Function Definition");
            $2->set_return_type($1->getname());
            active_function = $2->getname();
            expected_ret_type = $1->getname();

            // Validate parameter uniqueness
            for (size_t idx = 0; idx < func_args.size(); ++idx) {
                for (size_t jdx = idx + 1; jdx < func_args.size(); ++jdx) {
                    if (func_args[idx]->getname() == func_args[jdx]->getname()) {
                        err_stream << "At line no: " << line_counter << " Multiple declaration of variable " << func_args[idx]->getname() << " in parameter of " << active_function << "\n\n";
                        total_errors++;
                    }
                }
                $2->add_param_type(func_args[idx]->get_return_type());
            }
            sym_tbl.insert($2);
        }
	}
	compound_statement
	{	
		log_stream<<"At line no: "<<line_counter<<" func_definition : type_specifier ID LPAREN parameter_list RPAREN compound_statement\n\n";
		log_stream<<$1->getname()<<" "<<$2->getname()<<"("<<$4->getname()<<")\n"<<$7->getname()<<"\n\n";
		$$ = new symbol_info($1->getname()+" "+$2->getname()+"("+$4->getname()+")\n"+$7->getname(),"func_def");
	}
	| type_specifier ID LPAREN RPAREN
	{
        symbol_info* existing_sym = sym_tbl.lookup(new symbol_info($2->getname(), "ID"));
        if (existing_sym != nullptr) {
            err_stream << "At line no: " << line_counter << " Multiple declaration of function " << $2->getname() << "\n\n";
            total_errors++;
        } else {
            $2->set_symbol_type("Function Definition");
            $2->set_return_type($1->getname());
            expected_ret_type = $1->getname();
            sym_tbl.insert($2);
        }
	}
	compound_statement
	{
		log_stream<<"At line no: "<<line_counter<<" func_definition : type_specifier ID LPAREN RPAREN compound_statement\n\n";
		log_stream<<$1->getname()<<" "<<$2->getname()<<"()\n"<<$6->getname()<<"\n\n";
		$$ = new symbol_info($1->getname()+" "+$2->getname()+"()\n"+$6->getname(),"func_def");
	}
	;

parameter_list : parameter_list COMMA type_specifier ID
	{
		log_stream<<"At line no: "<<line_counter<<" parameter_list : parameter_list COMMA type_specifier ID\n\n";
		log_stream<<$1->getname()<<","<<$3->getname()<<" "<<$4->getname()<<"\n\n";
		$$ = new symbol_info($1->getname()+","+$3->getname(),"parameter_list");

		$4->set_symbol_type("Variable");
		$4->set_return_type($3->getname());
		func_args.push_back($4);
		arg_counter++;
	}
	| parameter_list COMMA type_specifier
	{
		log_stream<<"At line no: "<<line_counter<<" parameter_list : parameter_list COMMA type_specifier\n\n";
		log_stream<<$1->getname()<<","<<$3->getname()<<"\n\n";
		$$ = new symbol_info($1->getname()+","+$3->getname(),"parameter_list");	
	}
	| type_specifier ID
	{
		log_stream<<"At line no: "<<line_counter<<" parameter_list : type_specifier ID\n\n";
		log_stream<<$1->getname()<<" "<<$2->getname()<<"\n\n";
		$$ = new symbol_info($1->getname(),"parameter_list");	

		$2->set_symbol_type("Variable");
		$2->set_return_type($1->getname());
		func_args.push_back($2);
		arg_counter++;
	}
	| type_specifier
	{
		log_stream<<"At line no: "<<line_counter<<" parameter_list : type_specifier\n\n";
		log_stream<<$1->getname()<<"\n\n";
		$$ = new symbol_info($1->getname(),"parameter_list");	
	}
	;

compound_statement : LCURL 
	{
		sym_tbl.enter_scope();
        if (arg_counter > 0) {
            for (auto arg : func_args) {
                sym_tbl.insert(arg);
            }
            arg_counter = 0;
            func_args.clear();
        }
	}
	statements RCURL
	{
		log_stream<<"At line no: "<<line_counter<<" compound_statement : LCURL statements RCURL\n\n";
		log_stream<<"{\n"+$3->getname()+"\n}\n\n";
		$$ = new symbol_info("{\n"+$3->getname()+"\n}","compound_statement");
		sym_tbl.print_all_scopes();
		sym_tbl.exit_scope();
	}
	| LCURL RCURL
	{
		log_stream<<"At line no: "<<line_counter<<" compound_statement : LCURL RCURL\n\n";
		log_stream<<"{\n}\n\n";
		sym_tbl.enter_scope();
		sym_tbl.print_all_scopes();
		sym_tbl.exit_scope();
		$$ = new symbol_info("{\n}","compound_statement");
	}
	;
 		    
var_declaration : type_specifier declaration_list SEMICOLON
	{
		log_stream<<"At line no: "<<line_counter<<" var_declaration : type_specifier declaration_list SEMICOLON\n\n";
		log_stream<<$1->getname()<<" "<<$2->getname()<<";\n\n";
		$$ = new symbol_info($1->getname()+" "+$2->getname()+";","var_declaration");

        if ($1->getname() == "void") {
            err_stream << "At line no: " << line_counter << " variable type can not be void \n\n";
            total_errors++;
        }

		stringstream var_stream($2->getname());
		string var_token;
		while (getline(var_stream, var_token, ',')) {
			symbol_info *new_var = new symbol_info(var_token, "ID");
			size_t left_bracket = var_token.find("[");
			size_t right_bracket = var_token.find("]");

			if (left_bracket != string::npos) {
				new_var->set_name(var_token.substr(0, left_bracket));
				new_var->set_symbol_type("Array");
				new_var->set_return_type($1->getname());
				string arr_size = var_token.substr(left_bracket + 1, right_bracket - left_bracket - 1);
				new_var->set_size(stoi(arr_size));
			} else {
				new_var->set_symbol_type("Variable");
				new_var->set_return_type($1->getname());
			}

			if (!sym_tbl.insert(new_var)) {
                err_stream << "At line no: " << line_counter << " Multiple declaration of variable " << new_var->getname() << "\n\n";
                total_errors++;
            }
    	}
	}
	;

type_specifier : INT
		{
			log_stream<<"At line no: "<<line_counter<<" type_specifier : INT\n\n";
			log_stream<<"int\n\n";
			$$ = new symbol_info("int","type");
	    }
 		| FLOAT
 		{
			log_stream<<"At line no: "<<line_counter<<" type_specifier : FLOAT\n\n";
			log_stream<<"float\n\n";
			$$ = new symbol_info("float","type");
	    }
 		| VOID
 		{
			log_stream<<"At line no: "<<line_counter<<" type_specifier : VOID\n\n";
			log_stream<<"void\n\n";
			$$ = new symbol_info("void","type");
	    }
 		;

declaration_list : declaration_list COMMA ID
		  {
 		  	log_stream<<"At line no: "<<line_counter<<" declaration_list : declaration_list COMMA ID\n\n";
 		  	log_stream<<$1->getname()+","<<$3->getname()<<"\n\n";
			$$ = new symbol_info($1->getname()+","+$3->getname(),"declaration_list");
 		  }
 		  | declaration_list COMMA ID LTHIRD CONST_INT RTHIRD
 		  {
 		  	log_stream<<"At line no: "<<line_counter<<" declaration_list : declaration_list COMMA ID LTHIRD CONST_INT RTHIRD\n\n";
 		  	log_stream<<$1->getname()+","<<$3->getname()<<"["<<$5->getname()<<"]\n\n";
			$$ = new symbol_info($1->getname()+","+$3->getname()+"["+$5->getname()+"]","declaration_list");
 		  }
 		  |ID
 		  {
 		  	log_stream<<"At line no: "<<line_counter<<" declaration_list : ID\n\n";
			log_stream<<$1->getname()<<"\n\n";
			$$ = new symbol_info($1->getname(),"declaration_list");
 		  }
 		  | ID LTHIRD CONST_INT RTHIRD
 		  {
 		  	log_stream<<"At line no: "<<line_counter<<" declaration_list : ID LTHIRD CONST_INT RTHIRD\n\n";
			log_stream<<$1->getname()<<"["<<$3->getname()<<"]\n\n";
            $$ = new symbol_info($1->getname()+"["+$3->getname()+"]","declaration_list");
 		  }
 		  ;

statements : statement
	   {
	    	log_stream<<"At line no: "<<line_counter<<" statements : statement\n\n";
			log_stream<<$1->getname()<<"\n\n";
			$$ = new symbol_info($1->getname(),"stmnts");
	   }
	   | statements statement
	   {
	    	log_stream<<"At line no: "<<line_counter<<" statements : statements statement\n\n";
			log_stream<<$1->getname()<<"\n"<<$2->getname()<<"\n\n";
			$$ = new symbol_info($1->getname()+"\n"+$2->getname(),"stmnts");
	   }
	   ;
	   
statement : var_declaration
	  {
	    	log_stream<<"At line no: "<<line_counter<<" statement : var_declaration\n\n";
			log_stream<<$1->getname()<<"\n\n";
			$$ = new symbol_info($1->getname(),"stmnt");
	  }
	  | func_definition
	  {
	  		log_stream<<"At line no: "<<line_counter<<" statement : func_definition\n\n";
            log_stream<<$1->getname()<<"\n\n";
            $$ = new symbol_info($1->getname(),"stmnt");
	  }
	  | expression_statement
	  {
	    	log_stream<<"At line no: "<<line_counter<<" statement : expression_statement\n\n";
			log_stream<<$1->getname()<<"\n\n";
			$$ = new symbol_info($1->getname(),"stmnt");
	  }
	  | compound_statement
	  {
	    	log_stream<<"At line no: "<<line_counter<<" statement : compound_statement\n\n";
			log_stream<<$1->getname()<<"\n\n";
			$$ = new symbol_info($1->getname(),"stmnt");
	  }
	  | FOR LPAREN expression_statement expression_statement expression RPAREN statement
	  {
	    	log_stream<<"At line no: "<<line_counter<<" statement : FOR LPAREN expression_statement expression_statement expression RPAREN statement\n\n";
			log_stream<<"for("<<$3->getname()<<$4->getname()<<$5->getname()<<")\n"<<$7->getname()<<"\n\n";
			$$ = new symbol_info("for("+$3->getname()+$4->getname()+$5->getname()+")\n"+$7->getname(),"stmnt");
	  }
	  | IF LPAREN expression RPAREN statement %prec LOWER_THAN_ELSE
	  {
	    	log_stream<<"At line no: "<<line_counter<<" statement : IF LPAREN expression RPAREN statement\n\n";
			log_stream<<"if("<<$3->getname()<<")\n"<<$5->getname()<<"\n\n";
			$$ = new symbol_info("if("+$3->getname()+")\n"+$5->getname(),"stmnt");
	  }
	  | IF LPAREN expression RPAREN statement ELSE statement
	  {
	    	log_stream<<"At line no: "<<line_counter<<" statement : IF LPAREN expression RPAREN statement ELSE statement\n\n";
			log_stream<<"if("<<$3->getname()<<")\n"<<$5->getname()<<"\nelse\n"<<$7->getname()<<"\n\n";
			$$ = new symbol_info("if("+$3->getname()+")\n"+$5->getname()+"\nelse\n"+$7->getname(),"stmnt");
	  }
	  | WHILE LPAREN expression RPAREN statement
	  {
	    	log_stream<<"At line no: "<<line_counter<<" statement : WHILE LPAREN expression RPAREN statement\n\n";
			log_stream<<"while("<<$3->getname()<<")\n"<<$5->getname()<<"\n\n";
			$$ = new symbol_info("while("+$3->getname()+")\n"+$5->getname(),"stmnt");
	  }
	  | PRINTLN LPAREN ID RPAREN SEMICOLON
	  {
	    	log_stream<<"At line no: "<<line_counter<<" statement : PRINTLN LPAREN ID RPAREN SEMICOLON\n\n";
			log_stream<<"printf("<<$3->getname()<<");\n\n"; 
            
            if (sym_tbl.lookup(new symbol_info($3->getname(), "ID")) == nullptr) {
                err_stream << "At line no: " << line_counter << " Undeclared variable " << $3->getname() << "\n\n";
                total_errors++;
            }
			$$ = new symbol_info("printf("+$3->getname()+");","stmnt");
	  }
	  | RETURN expression SEMICOLON
	  {
	    	log_stream<<"At line no: "<<line_counter<<" statement : RETURN expression SEMICOLON\n\n";
			log_stream<<"return "<<$2->getname()<<";\n\n";
            
            if (expected_ret_type != "" && expected_ret_type != "void" && expected_ret_type != $2->get_return_type()) {
                 err_stream << "At line no: " << line_counter << " Return type mismatch\n\n";
                 total_errors++;
            }
			$$ = new symbol_info("return "+$2->getname()+";","stmnt");
	  }
	  ;
	  
expression_statement : SEMICOLON
			{
				log_stream<<"At line no: "<<line_counter<<" expression_statement : SEMICOLON\n\n";
				log_stream<<";\n\n";
				$$ = new symbol_info(";","expr_stmt");
	        }			
			| expression SEMICOLON 
			{
				log_stream<<"At line no: "<<line_counter<<" expression_statement : expression SEMICOLON\n\n";
				log_stream<<$1->getname()<<";\n\n";
				$$ = new symbol_info($1->getname()+";","expr_stmt");
	        }
			;
	  
variable : ID 	
      {
	    log_stream<<"At line no: "<<line_counter<<" variable : ID\n\n";
		log_stream<<$1->getname()<<"\n\n";
        
        symbol_info* found_sym = sym_tbl.lookup(new symbol_info($1->getname(), "ID"));
        $$ = new symbol_info($1->getname(), "varbl");
        if (found_sym == nullptr) {
            err_stream << "At line no: " << line_counter << " Undeclared variable " << $1->getname() << "\n\n";
            total_errors++;
            $$->set_return_type("undefined");
        } else if (found_sym->get_symbol_type() == "Array") {
            err_stream << "At line no: " << line_counter << " variable is of array type : " << $1->getname() << "\n\n";
            total_errors++;
            $$->set_return_type("undefined");
        } else {
            $$->set_return_type(found_sym->get_return_type());
        }
	 }	
	 | ID LTHIRD expression RTHIRD 
	 {
	 	log_stream<<"At line no: "<<line_counter<<" variable : ID LTHIRD expression RTHIRD\n\n";
		log_stream<<$1->getname()<<"["<<$3->getname()<<"]\n\n";
		
        symbol_info* found_sym = sym_tbl.lookup(new symbol_info($1->getname(), "ID"));
        $$ = new symbol_info($1->getname()+"["+$3->getname()+"]","varbl");
        if (found_sym == nullptr) {
            err_stream << "At line no: " << line_counter << " Undeclared variable " << $1->getname() << "\n\n";
            total_errors++;
            $$->set_return_type("undefined");
        } else if (found_sym->get_symbol_type() != "Array") {
            err_stream << "At line no: " << line_counter << " variable is not of array type : " << $1->getname() << "\n\n";
            total_errors++;
            $$->set_return_type("undefined");
        } else if ($3->get_return_type() != "int") {
            err_stream << "At line no: " << line_counter << " array index is not of integer type : " << $1->getname() << "\n\n";
            total_errors++;
            $$->set_return_type("undefined");
        } else {
            $$->set_return_type(found_sym->get_return_type());
        }
	 }
	 ;
	 
expression : logic_expression
	   {
	    	log_stream<<"At line no: "<<line_counter<<" expression : logic_expression\n\n";
			log_stream<<$1->getname()<<"\n\n";
			$$ = new symbol_info($1->getname(),"expr");
            $$->set_return_type($1->get_return_type());
	   }
	   | variable ASSIGNOP logic_expression 	
	   {
	    	log_stream<<"At line no: "<<line_counter<<" expression : variable ASSIGNOP logic_expression\n\n";
			log_stream<<$1->getname()<<"="<<$3->getname()<<"\n\n";
			$$ = new symbol_info($1->getname()+"="+$3->getname(),"expr");

            if ($3->get_return_type() == "void") {
                err_stream << "At line no: " << line_counter << " operation on void type \n\n";
                total_errors++;
            } else if ($1->get_return_type() != "undefined" && $3->get_return_type() != "undefined") {
                if ($1->get_return_type() == "int" && $3->get_return_type() == "float") {
                    err_stream << "At line no: " << line_counter << " Warning: Assignment of float value into variable of integer type \n\n";
                    total_errors++;
                } else if ($1->get_return_type() != $3->get_return_type()) {
                    err_stream << "At line no: " << line_counter << " Type mismatch\n\n";
                    total_errors++;
                }
            }
            $$->set_return_type($1->get_return_type());
	   }
	   ;
			
logic_expression : rel_expression
	     {
	    	log_stream<<"At line no: "<<line_counter<<" logic_expression : rel_expression\n\n";
			log_stream<<$1->getname()<<"\n\n";
			$$ = new symbol_info($1->getname(),"lgc_expr");
            $$->set_return_type($1->get_return_type());
	     }	
		 | rel_expression LOGICOP rel_expression 
		 {
	    	log_stream<<"At line no: "<<line_counter<<" logic_expression : rel_expression LOGICOP rel_expression\n\n";
			log_stream<<$1->getname()<<$2->getname()<<$3->getname()<<"\n\n";
			$$ = new symbol_info($1->getname()+$2->getname()+$3->getname(),"lgc_expr");
            $$->set_return_type("int");
	     }	
		 ;
			
rel_expression	: simple_expression
		{
	    	log_stream<<"At line no: "<<line_counter<<" rel_expression : simple_expression\n\n";
			log_stream<<$1->getname()<<"\n\n";
			$$ = new symbol_info($1->getname(),"rel_expr");
            $$->set_return_type($1->get_return_type());
	    }
		| simple_expression RELOP simple_expression
		{
	    	log_stream<<"At line no: "<<line_counter<<" rel_expression : simple_expression RELOP simple_expression\n\n";
			log_stream<<$1->getname()<<$2->getname()<<$3->getname()<<"\n\n";
			$$ = new symbol_info($1->getname()+$2->getname()+$3->getname(),"rel_expr");
            $$->set_return_type("int");
	    }
		;
				
simple_expression : term
          {
	    	log_stream<<"At line no: "<<line_counter<<" simple_expression : term\n\n";
			log_stream<<$1->getname()<<"\n\n";
			$$ = new symbol_info($1->getname(),"simp_expr");
            $$->set_return_type($1->get_return_type());
	      }
		  | simple_expression ADDOP term 
		  {
	    	log_stream<<"At line no: "<<line_counter<<" simple_expression : simple_expression ADDOP term\n\n";
			log_stream<<$1->getname()<<$2->getname()<<$3->getname()<<"\n\n";
            
            string result_type = "int";
            if ($1->get_return_type() == "float" || $3->get_return_type() == "float") result_type = "float";
            if ($1->get_return_type() == "void" || $3->get_return_type() == "void") {
                 err_stream << "At line no: " << line_counter << " operation on void type \n\n";
                 total_errors++;
                 result_type = "undefined";
            }
            if ($1->get_return_type() == "undefined" || $3->get_return_type() == "undefined") {
                 result_type = "undefined";
            }

			$$ = new symbol_info($1->getname()+$2->getname()+$3->getname(),"simp_expr");
            $$->set_return_type(result_type);
	      }
		  ;
					
term :	unary_expression
     {
	    	log_stream<<"At line no: "<<line_counter<<" term : unary_expression\n\n";
			log_stream<<$1->getname()<<"\n\n";
			$$ = new symbol_info($1->getname(),"term");
            $$->set_return_type($1->get_return_type());
	 }
     |  term MULOP unary_expression
     {
	    	log_stream<<"At line no: "<<line_counter<<" term : term MULOP unary_expression\n\n";
			log_stream<<$1->getname()<<$2->getname()<<$3->getname()<<"\n\n";
            string operator_type = $2->getname();
            string result_type = "int";

            if ($1->get_return_type() == "void" || $3->get_return_type() == "void") {
                 err_stream << "At line no: " << line_counter << " operation on void type \n\n";
                 total_errors++;
                 result_type = "undefined";
            }
            if ($1->get_return_type() == "undefined" || $3->get_return_type() == "undefined") {
                 result_type = "undefined";
            }
            if (result_type != "undefined") {
                if (operator_type == "%") {
                    if ($1->get_return_type() != "int" || $3->get_return_type() != "int") {
                        err_stream << "At line no: " << line_counter << " Modulus operator on non integer type \n\n";
                        total_errors++;
                    }
                    if ($3->getname() == "0") {
                        err_stream << "At line no: " << line_counter << " Modulus by 0 \n\n";
                        total_errors++;
                    }
                } else {
                    if ($1->get_return_type() == "float" || $3->get_return_type() == "float") {
                        result_type = "float";
                    }
                    if (operator_type == "/" && $3->getname() == "0") {
                        err_stream << "At line no: " << line_counter << " Division by 0 \n\n";
                        total_errors++;
                    }
                }
            }
			
			$$ = new symbol_info($1->getname()+$2->getname()+$3->getname(),"term");
            $$->set_return_type(result_type);
	 }
     ;

unary_expression : ADDOP unary_expression
		 {
	    	log_stream<<"At line no: "<<line_counter<<" unary_expression : ADDOP unary_expression\n\n";
			log_stream<<$1->getname()<<$2->getname()<<"\n\n";
			$$ = new symbol_info($1->getname()+$2->getname(),"un_expr");
            $$->set_return_type($2->get_return_type());
	     }
		 | NOT unary_expression 
		 {
	    	log_stream<<"At line no: "<<line_counter<<" unary_expression : NOT unary_expression\n\n";
			log_stream<<"!"<<$2->getname()<<"\n\n";
			$$ = new symbol_info("!"+$2->getname(),"un_expr");
	     }
		 | factor 
		 {
	    	log_stream<<"At line no: "<<line_counter<<" unary_expression : factor\n\n";
			log_stream<<$1->getname()<<"\n\n";
			$$ = new symbol_info($1->getname(),"un_expr");
            $$->set_return_type($1->get_return_type());
	     }
		 ;
	
factor	: variable
    {
	    log_stream<<"At line no: "<<line_counter<<" factor : variable\n\n";
		log_stream<<$1->getname()<<"\n\n";
		$$ = new symbol_info($1->getname(),"fctr");
        $$->set_return_type($1->get_return_type());
	}
	| ID LPAREN argument_list RPAREN
	{
	    log_stream<<"At line no: "<<line_counter<<" factor : ID LPAREN argument_list RPAREN\n\n";
		log_stream<<$1->getname()<<"("<<$3->getname()<<")\n\n";
		
        symbol_info* func_sym = sym_tbl.lookup(new symbol_info($1->getname(), "ID"));
        $$ = new symbol_info($1->getname()+"("+$3->getname()+")","fctr");

        if (func_sym == nullptr) {
            err_stream << "At line no: " << line_counter << " Undeclared function: " << $1->getname() << "\n\n";
            total_errors++;
            $$->set_return_type("undefined");
        } else if (func_sym->get_symbol_type() != "Function Definition") {
            err_stream << "At line no: " << line_counter << " '" << $1->getname() << "' is not a function\n\n";
            total_errors++;
            $$->set_return_type("undefined");
        } else {
            vector<string> expected_args = func_sym->get_params();
            if (func_args.size() != expected_args.size()) {
                err_stream << "At line no: " << line_counter << " Inconsistencies in number of arguments in function call: " << $1->getname() << "\n\n";
                total_errors++;
            } else {
                for (size_t idx = 0; idx < func_args.size(); ++idx) {
                    if (func_args[idx]->get_return_type() != "undefined" && func_args[idx]->get_return_type() != expected_args[idx]) {
                         err_stream << "At line no: " << line_counter << " argument " << idx+1 << " type mismatch in function call: " << $1->getname() << "\n\n";
                         total_errors++;
                    }
                }
            }
            $$->set_return_type(func_sym->get_return_type());
        }
        func_args.clear();
	}
	| LPAREN expression RPAREN
	{
	   	log_stream<<"At line no: "<<line_counter<<" factor : LPAREN expression RPAREN\n\n";
		log_stream<<"("<<$2->getname()<<")\n\n";
		$$ = new symbol_info("("+$2->getname()+")","fctr");
        $$->set_return_type($2->get_return_type());
	}
	| CONST_INT 
	{
	    log_stream<<"At line no: "<<line_counter<<" factor : CONST_INT\n\n";
		log_stream<<$1->getname()<<"\n\n";
		$$ = new symbol_info($1->getname(),"fctr");
        $$->set_return_type("int");
	}
	| CONST_FLOAT
	{
	    log_stream<<"At line no: "<<line_counter<<" factor : CONST_FLOAT\n\n";
		log_stream<<$1->getname()<<"\n\n";
		$$ = new symbol_info($1->getname(),"fctr");
        $$->set_return_type("float");
	}
	| variable INCOP 
	{
	    log_stream<<"At line no: "<<line_counter<<" factor : variable INCOP\n\n";
		log_stream<<$1->getname()<<"++\n\n";
		$$ = new symbol_info($1->getname()+"++","fctr");
	}
	| variable DECOP
	{
	    log_stream<<"At line no: "<<line_counter<<" factor : variable DECOP\n\n";
		log_stream<<$1->getname()<<"--\n\n";
		$$ = new symbol_info($1->getname()+"--","fctr");
	}
	;
	
argument_list : arguments
			  {
					log_stream<<"At line no: "<<line_counter<<" argument_list : arguments\n\n";
					log_stream<<$1->getname()<<"\n\n";
					$$ = new symbol_info($1->getname(),"arg_list");
			  }
			  |
			  {
					log_stream<<"At line no: "<<line_counter<<" argument_list :\n\n";
					log_stream<<"\n\n";
					$$ = new symbol_info("","arg_list");
			  }
			  ;
	
arguments : arguments COMMA logic_expression
		  {
				log_stream<<"At line no: "<<line_counter<<" arguments : arguments COMMA logic_expression\n\n";
				log_stream<<$1->getname()<<","<<$3->getname()<<"\n\n";
                func_args.push_back($3);
				$$ = new symbol_info($1->getname()+","+$3->getname(),"arg");
		  }
	      | logic_expression
	      {
				log_stream<<"At line no: "<<line_counter<<" arguments : logic_expression\n\n";
				log_stream<<$1->getname()<<"\n\n";
                func_args.push_back($1);
				$$ = new symbol_info($1->getname(),"arg");
		  }
	      ;
 
%%

int main(int argc, char *argv[])
{
	if(argc != 2) 
	{
		cout<<"Please provide input file\n";
		return 0;
	}
	yyin = fopen(argv[1], "r");
	log_stream.open("22101371_log.txt", ios::trunc);
    err_stream.open("22101371_error.txt", ios::trunc);

	sym_tbl.enter_scope();
	
	if(yyin == NULL)
	{
		cout<<"File not found\n";
		return 0;
	}
	
	yyparse();
	
	log_stream << "\nTotal lines: " << line_counter << "\n";
    log_stream << "Total errors: " << total_errors << "\n";
	log_stream.close();

    err_stream << "Total errors: " << total_errors << "\n";
    err_stream.close();
	
	fclose(yyin);
	
	return 0;
}
