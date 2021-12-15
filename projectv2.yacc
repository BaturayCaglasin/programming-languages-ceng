%{
#include <stdio.h>
#include <iostream>
#include <string>
#include <map>
	using namespace std;
	#include "y.tab.h"
	extern FILE *yyin;
	extern int yylex();
	void yyerror(string s);
	bool errorFlag=false;
	extern int linenum;
  extern char * yytext;
  map<string,string> values;

%}

%union
{
int number;
char *str;
}

%token GRT LESS NL OP CP CB CBO CBC IF FI RULEOP EQUALSYM SPACE UPPERCASE LOWERCASE //these are my tokens

%token<str> UPPERCASE
%token<str> LOWERCASE

%type <str> terminal
%type <str> nterminal
%type <str> tvalue
%type <str> value

%type <str> lhss  // the lhss has a type
%type <str> rhss // the rhss has a type
%type <str> lhs  // the lhs has a type
%type <str> rhs // the rhs has a type
%type <str> assignment // the decl has a type


%%

statements:
	statement statements
	|

	;

statement:assignment

	;

assignment:
lhss RULEOP rhss CB
{

values[string($1)] = $3;
cout<<$1<<" -> "<<values[string($1)]<<endl;

}
;

rhss:
 rhss rhs
 |
 rhs
 ;

 lhss:
  lhss lhs
  |
  lhs
  ;

lhs:
nterminal
;

rhs:
terminal | nterminal;


terminal:
tvalue {$$=strdup($1);}
;

nterminal:
value {$$=strdup($1);}
;

value:
  	LESS UPPERCASE GRT {$$ = strdup($2);}
  	;

tvalue:
    LOWERCASE {$$ = strdup($1);}
    ;

%%
void yyerror(string s){
	cerr<<"Error at line: "<<linenum<<endl;
	errorFlag=true;
}
int yywrap(){
	return 1;
}
int main(int argc, char *argv[])
{
    /* Call the lexer, then quit. */
    yyin=fopen(argv[1],"r");
    yyparse();
    fclose(yyin);
	  if(errorFlag==false)
		cout<<"completed without an error"<<endl;
    return 0;
}
