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
				return(INT);
			}

void			{
				return(VOID);
			}

boolean			{
				return(BOOLEAN);
			}

begin			{
				return(BEG);
			}

end			{
				return(END);
			}

if			{
				return(IF); 
			}

then			{
				return(THEN);
			}

else			{
				return(ELSE);
			}

while			{
				return(WHILE);
			}

do			{
				return(DO);
			}

return			{
				return(RET);
			}

read			{
				return(READ);
			}

write			{
				return(WRITE);
			}

and			{
				return(AND);
			}

or			{
				return(OR);
			}

true			{
				return(TRUE);
			}

false			{
				return(FALSE);
			}

not			{
				return(NOT);
			}

"<="			{
				return(LE);
			}

"<"			{
				return(LT);
			}

">="			{
				return(GE);
			}

">"			{
				return(GT);
			}

"=="			{
				return(EQ);
			}

"!="			{
				return(NE);
			}

[a-zA-Z][a-zA-Z0-9]*	{
				yylval.string = strdup(yytext);
				return (ID);
			}

[0-9][0-9]*		{
				yylval.value = atoi((const char *)yytext);
				return(NUM);
			}

[\[\]=\-+&|,]		{
				return(*yytext);
			}

[ \t]			{
			}

\n			{
				line++;
				return(*yytext);
			}


%%

int yywrap(void) {
	return 1;
}
