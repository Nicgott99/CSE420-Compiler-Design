#!/bin/bash

yacc -d -y --debug --verbose 22101371.y
echo 'Parser files generated'
g++ -w -c -o y.o y.tab.c
echo 'Parser compiled'
flex 22101371.l
echo 'Lexer generated'
g++ -fpermissive -w -c -o l.o lex.yy.c
echo 'Lexer compiled'
g++ y.o l.o
echo 'Build complete'
./a.exe input.c
echo 'Output:'
cat 22101371_log.txt