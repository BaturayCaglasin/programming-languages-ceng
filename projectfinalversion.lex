terminals [a-zA-Z0-9]+
nonterminals <[A-Z]+>
missinggrt <[A-Z]+
missingless [A-Z]+>


%{
#include <stdio.h>
#include <string.h>
#include "y.tab.h"
int linenum=1;
%}
%%

"(" return OP;
")" return CP;
"{" return CBO;
"}" return CBC;
";" return CB;
"if" return IF;
"fi" return FI;
"n" return NL;
"->" return RULEOP;


{terminals} {yylval.str = strdup(yytext);return TERMINALS;}
{nonterminals} {yylval.str = strdup(yytext);return NONTERMINALS;}
{missinggrt} {yylval.str = strdup(yytext);return MISSINGGRT;}
{missingless} {yylval.str = strdup(yytext);return MISSINGLESS;}

\n	{linenum++;}
[ \t]+
[ \n]+
%%
