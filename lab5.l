/*
This lex file takes in input and gives token and characters related to the
ALGOL-C grammar structure. I also keeps track of the line number.

Michael Smith
March 2020

*/
%{

int debug = 0;
int line = 1;
#include <stdio.h>
#include <stdlib.h>
#include <string.h>
#include "y.tab.h"

%}

%%

int			{
				if(debug) printf("found \"type spec: int\"\n");
				return(INT);
			}

void			{
				if(debug) printf("found \"void\"\n");
				return(VOID);
			}

boolean			{
				if(debug) printf("found \"boolean\"\n");
				return(BOOLEAN);
			}

begin			{
				if(debug) printf("found \"begin\"\n");
				return(BEG);
			}

end			{
				if(debug) printf("found \"end\"\n");
				return(END);
			}

if			{
				if(debug) printf("found \"if\"\n");
				return(IF); 
			}

then			{
				if(debug) printf("found \"then\"\n");
				return(THEN);
			}

else			{
				if(debug) printf("found \"else\"\n");
				return(ELSE);
			}

while			{
				if(debug) printf("found \"while\"\n");
				return(WHILE);
			}

do			{
				if(debug) printf("found \"do\"\n");
				return(DO);
			}

return			{
				if(debug) printf("found \"return\"\n");
				return(RET);
			}

read			{
				if(debug) printf("found \"read\"\n");
				return(READ);
			}

write			{
				if(debug) printf("found \"write\"\n");
				return(WRITE);
			}

and			{
				if(debug) printf("found \"and\"\n");
				return(AND);
			}

or			{
				if(debug) printf("found \"or\"\n");
				return(OR);
			}

true			{
				if(debug) printf("found \"true\"\n");
				return(TRUE);
			}

false			{
				if(debug) printf("found \"false\"\n");
				return(FALSE);
			}

not			{
				if(debug) printf("found \"not\"\n");
				return(NOT);
			}

"<="			{
				if(debug) printf("found \"LE\"\n");
				return(LE);
			}

"<"			{
				if(debug) printf("found \"LT\"\n");
				return(LT);
			}

">="			{
				if(debug) printf("found \"GE\"\n");
				return(GE);
			}

">"			{
				if(debug) printf("found \"GT\"\n");
				return(GT);
			}

"=="			{
				if(debug) printf("found \"EQ\"\n");
				return(EQ);
			}

"!="			{
				if(debug) printf("found \"NE\"\n");
				return(NE);
			}

[a-zA-Z][a-zA-Z0-9]*	{
				yylval.string = strdup(yytext);
				if(debug) printf("found \"ID: %s\"\n", yytext);
				return (ID);
			}

[0-9][0-9]*		{
				yylval.value = atoi((const char *)yytext);
				if(debug) printf("found \"NUM: %s\"\n", yytext);
				return(NUM);
			}

[\[\]\=\-+&|/\,\;\(\)]	{
				if(debug) printf("found \"char: %s\"\n", yytext);
				return(*yytext);
			}

[ \t]			{
			}

\n			{
				if(debug) printf("found \"new line\"\n");
				line++;
			}


%%

int yywrap(void) {
	return 1;
}
