 %{
  #include <stdio.h>
  #include <sstream>
  #include <iostream>
  #include <string>
  #include <map>
  #include <vector>
	using namespace std;
	#include "y.tab.h"
	extern FILE *yyin;
	extern int yylex();
	void yyerror(string s);
	bool errorFlag=false;
	extern int linenum;
	map<string,string> values;
  vector<string> v;


%}

%union
{
int number;
char *str;
}

%token GRT LESS NL OP CP CB CBO CBC IF FI RULEOP

%token <str> NONTERMINALS
%token <str> TERMINALS
%token <str> MISSINGGRT
%token <str> MISSINGLESS


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
v.insert(v.begin(), combinedl);
}
;

rhs:
TERMINALS
{
string combinedr = string($1);
$$ = strdup(combinedr.c_str());
v.push_back(combinedr);
}
|
NONTERMINALS
{
string combinedr = string($1);
$$ = strdup(combinedr.c_str());
v.push_back(combinedr);
}
|
NONTERMINALS TERMINALS
{
string combinedr = string($1) + " " +string($2);
$$ = strdup(combinedr.c_str());
v.push_back(combinedr);
}
|
TERMINALS TERMINALS
{
string combinedr = string($1) + " " +string($2);
$$ = strdup(combinedr.c_str());
v.push_back(combinedr);
}
|
TERMINALS NONTERMINALS
{
string combinedr = string($1) + " " +string($2);
$$ = strdup(combinedr.c_str());
v.push_back(combinedr);
}
|
TERMINALS NONTERMINALS TERMINALS
{
string combinedr = string($1) + " " +string($2) + " " + string($3);
$$ = strdup(combinedr.c_str());
v.push_back(combinedr);
}
|
TERMINALS TERMINALS TERMINALS
{
string combinedr = string($1) + " " +string($2) + " " + string($3);
$$ = strdup(combinedr.c_str());
v.push_back(combinedr);
}
|
NONTERMINALS TERMINALS NONTERMINALS
{
string combinedr = string($1) + " " +string($2) + " " + string($3);
$$ = strdup(combinedr.c_str());
v.push_back(combinedr);
}
|
NONTERMINALS NONTERMINALS NONTERMINALS
{
string combinedr = string($1) + " " +string($2) + " " + string($3);
$$ = strdup(combinedr.c_str());
v.push_back(combinedr);
}
;

//apply left recursion elimination



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
    cout << "***vector***"<<endl;
    for (int i = 0; i < v.size(); ++i)
       {
            cout << v[i]<<endl;
       }
    return 0;
}
