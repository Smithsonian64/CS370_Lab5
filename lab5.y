/*
The yacc file reads tokens taken from lex and parses them according to the
ALGOL-C grammar structure. All constants will be emitted through stderr and if
there is an error it will be emmitted through stderr as well as the line number.

This yacc routine will exit as soon as an error is encountered.

ALGOL-C ignores whitespaces and newlines so if there is a lot of empty lines to
to space out a program line counts may be inaccurate for errors. for example, a mispelled END token will be parsed as an ID and the routine will not detect an
error until, most likely, the next token, even if it is several empty newlines
away. See test.al for an example. The error is on line 10 but the routine will
not emit an error until line 12.

Michael Smith
March 2020
*/
%{
#include <stdio.h>
#include <ctype.h>
#include "lex.yy.c"

int mydebug = 0;

extern int line;

void yyerror (s)
	char *s;
{
	fprintf(stderr, "error on line %d: %s\nAborting...\n", line, s);
	exit(0);

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

%type<value> NUM
%type<string> ID

%%

program		:	decls_list	 
		;

decls_list 	:	dec
	   	|	dec decls_list
		;

dec		:	var_dec
     		|	fun_dec
		;

var_dec		:	type_spec var_list ';'
	 	;

var_list	:	ID
	 	|	ID '[' NUM ']'
			{
				fprintf(stderr, "Found constant: %d on line: %d\n",$3, line);
			}
		|	ID ',' var_list 
		|	ID '[' NUM ']' ',' var_list
			{
				fprintf(stderr, "Found constant: %d on line: %d\n",$3, line);
			}
		;

type_spec	:	INT
	  	|	VOID
		|	BOOLEAN
	  	;

fun_dec		:	type_spec ID '(' params ')' compound_stmt
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
	   	|	local_decs var_dec
		;

stmt_list	:	/*nothing*/
	  	|	stmt_list stmt
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
	       	|	IF expression THEN stmt ELSE stmt
		;

iteration_stmt	:	WHILE expression DO stmt
	       	;

return_stmt	:	RET ';'
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

additive_expression	:	term
			|	term addop additive_expression
			;

addop		:	'+'
       		|	'-'
		;

term		:	factor
		|	factor multop term
		;

multop		:	'*'
		|	'/'
		|	AND
		|	OR
		;

factor		:	'(' expression	')'
		|	NUM
			{
				fprintf(stderr, "Found constant: %d on line: %d\n",$1, line);
			}
		|	variable
		|	call
		|	TRUE
		|	FALSE
		|	NOT factor
		;

call		:	ID '(' args ')'
      		|	
		;

args		:	arg_list
      		|	/*empty*/
		;

arg_list	:	expression
	 	|	expression ',' arg_list
		;

%%		

int main(void) {
	yyparse();
	fprintf(stderr, "No errors found\n");
	return 1;
}

