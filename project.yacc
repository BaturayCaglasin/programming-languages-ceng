%{
	#include <stdio.h>
	#include <stdlib.h>
	#include <iostream>
	#include <string>
	using namespace std;
	#include "y.tab.h"
	extern FILE *yyin;
	extern int yylex();
	void yyerror(string s);
	bool errorFlag=false;
	extern int linenum;

%}

%union
{
int number;
char * str;
}

%token GRT LESS NL OP CP CB CBO CBC IF RULEOP //these are my tokens

%token <str> UPPERCASE  //uppercase characters are char
%token <str> LOWERCASE  //lowercase characters are char
%token <str> LETTER  //letter characters are char

%type <str> terminal  // the terminals have a type
%type <str> nterminal // the non-terminals have a type

%type <str> lhss  // the terminals have a type
%type <str> rhss // the non-terminals have a type

%%

decls:
 decls decl
 |
 decl;


decl:
lhss RULEOP rhss CB
{
 cout<<"Matched a declaration."<<$1<<$3<<endl;
}
;



rhss:
 rhss rhs
 {
   $$ = $1;
 }
 |
 rhs
 {
   $$ = $1;
 }
 ;

 lhss:
  lhss lhs
  {
    $$ = $1;
  }
  |
  lhs
  {
    $$ = $1;
  }
  ;

lhs:
nterminal;

rhs:
terminal | nterminal;

terminal:LOWERCASE
;

nterminal:LESS UPPERCASE GRT
|
LESS LETTER GRT
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
