all:	lab5

lab5:	y.tab.c
	gcc y.tab.c -o lab5

y.tab.c:clean
	lex lab5.l
	yacc -d lab5.y

clean:
	rm -f y.tab.c y.tab.h
