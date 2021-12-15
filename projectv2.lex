digit	[0-9]
uppercase [A-Z]
lowercase [a-z]
letter [A-Za-z]

%{
#include <stdio.h>
#include <string.h>
#include "y.tab.h"
int linenum=1;
%}
%%


"(" return OP;
\= 	return EQUALSYM;
")" return CP;
"{" return CBO;
"\s" return SPACE;
"}" return CBC;
";" return CB;
"if" return IF;
"fi" return FI;
"n" return NL;
"->" return RULEOP;
"<" return LESS;
">" return GRT;


[A-Z]+
{
yylval.str=strdup(yytext);
return UPPERCASE;
}

[a-z]+
{
yylval.str=strdup(yytext);
return LOWERCASE;
}

\n	{linenum++;}
[ \t]+
[ \n]+
%%
