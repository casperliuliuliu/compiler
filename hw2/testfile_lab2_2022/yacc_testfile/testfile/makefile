all:	clean y.tab.c lex.yy.c
	gcc lex.yy.c y.tab.c -lfl -o calc

y.tab.c:
	bison -y -d mod.y

lex.yy.c:
	flex mod.l

clean:
	rm -f calc lex.yy.c y.tab.c y.tab.h
