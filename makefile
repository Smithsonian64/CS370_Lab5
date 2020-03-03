#Lab5
#Michael Smith
#March 2020
#Lab5 can parse either by user input or an input file
#ALGOL-C grammar and return any errors
#input: user input or input file
#output: indication of any errors
#

all:	lab5

lab5:	y.tab.c
	gcc y.tab.c -o lab5

y.tab.c:clean
	lex lab5.l
	yacc -d lab5.y

clean:
	rm -f y.tab.c y.tab.h
