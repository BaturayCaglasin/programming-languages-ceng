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

"<" return LESS;
">" return GRT;
"(" return OP;
")" return CP;
"{" return CBO;
"}" return CBC;
";" return CB;
"if" return IF;
"n" return NL;
"->" return RULEOP;


[A-Z]+ {
yylval.str=strdup(yytext);
return UPPERCASE;
}

[a-z]+ {
yylval.str=strdup(yytext);
return LOWERCASE;
}

[A-Za-z]+ {
yylval.str=strdup(yytext);
return LETTER;
}

\n	{linenum++;}
[ \t]+
[ \n]+
%%
