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
  extern char * yytext;

%}

%union
{
int number;
char *str;
}

%token GRT LESS NL OP CP CB CBO CBC IF RULEOP EQUALSYM //these are my tokens

%token <str> UPPERCASE  //uppercase characters are char
%token <str> LOWERCASE  //lowercase characters are char
%token <str> LETTER  //letter characters are char
%token <str> LESS  //less characters are char
%token <str> GRT  //greater characters are char


%type <str> terminal  // the terminals have a type
%type <str> nterminal // the non-terminals have a type

%type <str> lhss  // the lhss has a type
%type <str> lhs  // the lhss has a type
%type <str> rhss // the rhss has a type
%type <str> decl // the decl has a type

%%

decls:
 decls decl
 |
 decl;


decl:
lhss RULEOP rhss CB
{
  cout<<" "<<"->"<<" "<<$3<<endl;

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

terminal:LOWERCASE
{
  $$=$1;
}
;

nterminal:LESS UPPERCASE GRT
{
  cout<<$1<<$2<<$3;
}
|
LESS LETTER GRT
{
  cout<<$1<<$2<<$3;
}
|
UPPERCASE GRT
{
  cout<<"missing < symbol in line:"<<linenum;
  errorFlag=true;
}
|
LETTER GRT
{
  cout<<"missing < symbol in line:"<<linenum;
  errorFlag=true;
}
|
LESS UPPERCASE
{
  cout<<"missing > symbol in line:"<<linenum;
  errorFlag=true;
}
|
LESS LETTER
{
  cout<<"missing > symbol in line:"<<linenum;
  errorFlag=true;
}
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
