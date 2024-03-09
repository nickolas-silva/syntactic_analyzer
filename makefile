all: owl

CPP=g++
FLEX=flex
BISON=bison

calc: lex.yy.c owl.tab.c
	$(CPP) lex.yy.c owl.tab.c -std=c++17 -o owl

lex.yy.c: owl.l
	$(FLEX) owl.l

calc.tab.c: owl.y
	$(BISON) -d owl.y

clean:
	rm owl lex.yy.c owl.tab.c owl.tab.h