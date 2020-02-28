%{
#include <stdio.h>
#include <ctype.h>
#include <stdbool.h>
#include "lex.yy.c"

extern int line;

void yyerror (s)
	char *s;
{
	printf("error on line %d: %s\n", line, s);
}
%}

%start program

%union {
	char * string;
	int value;
}

%token ID NUM INT VOID BOOLEAN BEG END IF THEN ELSE WHILE DO RET READ WRITE
%token LE LT GE GT EQ NE
%token AND OR TRUE FALSE NOT
%%

program		:	decls_list	
		;

decls_list 	:	dec
	   	|	decls_list dec
		;

dec		:	var_dec
     		|	fun_dec
		;

var_dec		:	type_spec var_list
	 	;

var_list	:	ID '\n'
	 	|	ID '[' NUM ']' '\n'
		|	ID ',' var_list '\n'
		|	ID '[' NUM ']' ',' var_list '\n'
		;

type_spec	:	INT
	  	|	VOID
		|	BOOLEAN
	  	;

fun_dec		:	type_spec ID '(' params ')' '\n' compound_stmt
	 	;

params		:	VOID
		|	param_list
		;

param_list	:	param
	   	|	param ',' param_list
		;

param		:	type_spec ID
       		|	type_spec ID '[' ']'
       		;

compound_stmt	:	BEG local_decs stmt_list END
	      	;

local_decs	:	/*nothing*/
	   	|	var_dec
		|	local_decs var_dec
		;

stmt_list	:	/*nothing*/
	  	|	stmt
		;

stmt		:	expression_stmt
      		|	compound_stmt
		|	selection_stmt
		|	iteration_stmt
		|	assignment_stmt
		|	return_stmt
		|	read_stmt
		|	write_stmt
		;

expression_stmt	:	expression ';'
		|	';'
		;

selection_stmt	:	IF expression THEN stmt
	       	|	IF expression THEN stmt '[' ELSE stmt ']'
		;

iteration_stmt	:	WHILE expression DO stmt
	       	;

return_stmt	:	RET
	    	|	RET expression ';'
		;

read_stmt	:	READ variable ';'
	  	;

write_stmt	:	WRITE expression ';'
	   	;

assignment_stmt	:	variable '=' simple_expression ';'
		;

expression	:	simple_expression
	   	;

variable	:	ID
	 	|	ID '[' expression ']'
		;

simple_expression	:	additive_expression
		  	|	additive_expression relop additive_expression
			;

relop		:	LE
       		|	LT
		|	GT
		|	GE
		|	EQ
		|	NE
		;

additive_expression	:	/*nothing*/
		    	|	term additive_expression
			|	term addop additive_expression
			;

addop		:	'+'
       		|	'-'
		;

term		:	/*nothing*/
      		|	factor
		|	factor multop term
		;

multop		:	'*'
		|	'/'
		|	AND
		|	OR
		;

factor		:	'(' expression	')'
		|	NUM
		|	variable
		|	call
		|	TRUE
		|	FALSE
		|	NOT factor
		;

call		:	ID '(' args ')'
      		|	
		;

args		:	/*nothing*/
      		|	arg_list
		;

arg_list	:	expression
	 	|	expression ',' arg_list
		;

%%		

int main(void) {
	yyparse();
	return 1;
}

