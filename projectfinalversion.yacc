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

 map<string,string> values;

%}

%union
{
int number;
char *str;
}

%token GRT LESS NL OP CP CB CBO CBC IF FI RULEOP //these are my tokens

%token <str> NONTERMINALS
%token <str> TERMINALS
%token <str> MISSINGGRT
%token <str> MISSINGLESS

//%type <str> valuel
//%type <str> valuer
%type <str> rhs
%type <str> lhs
%type <str> assignment

%%

statements:
	statement statements
	|
  statement
	;

statement:
	assignment
	|
	comparison
	;

assignment:
lhs RULEOP rhs CB
{
  cout<<$1<<" "<<"->"<<" "<<$3<<endl;
}
;

comparison:
  MISSINGGRT RULEOP rhs CB
  {
    cout<<"missing > symbol in: "<<linenum<<endl;
    errorFlag=true;
  }
  |
  MISSINGLESS RULEOP rhs CB
  {
    cout<<"missing < symbol in: "<<linenum<<endl;
    errorFlag=true;
  }
  ;



lhs:
NONTERMINALS
{
string combinedl = string($1);
$$ = strdup(combinedl.c_str());
}
;


rhs:
TERMINALS 
{
string combinedl = string($1);
$$ = strdup(combinedl.c_str());
}
|
NONTERMINALS
{
string combinedl = string($1);
$$ = strdup(combinedl.c_str());
}
|
NONTERMINALS TERMINALS
{
string combinedl = string($1) + " " +string($2);
$$ = strdup(combinedl.c_str());
}
|
TERMINALS NONTERMINALS
{
string combinedl = string($1) + " " +string($2);
$$ = strdup(combinedl.c_str());
}
|
TERMINALS NONTERMINALS TERMINALS
{
string combinedl = string($1) + " " +string($2) + " " + string($3);
$$ = strdup(combinedl.c_str());
}
|
TERMINALS TERMINALS TERMINALS
{
string combinedl = string($1) + " " +string($2) + " " + string($3);
$$ = strdup(combinedl.c_str());
}
|
NONTERMINALS TERMINALS NONTERMINALS
{
string combinedl = string($1) + " " +string($2) + " " + string($3);
$$ = strdup(combinedl.c_str());
}
|
NONTERMINALS NONTERMINALS NONTERMINALS
{
string combinedl = string($1) + " " +string($2) + " " + string($3);
$$ = strdup(combinedl.c_str());
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
