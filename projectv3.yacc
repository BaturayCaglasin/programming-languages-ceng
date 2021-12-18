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

%token <str> UPPERCASE  //uppercase characters are char
%token <str> LOWERCASE  //lowercase characters are char
%token <str> LETTER  //letter characters are char

%type <str> valuel  // the terminals have a type
%type <str> rhs // the right-hand-side have a type

%type <str> lhs  // the lhss has a type
%type <str> lhss  // the lhss has a type
%type <str> assignment // the decl has a type

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
lhss RULEOP rhs CB
{
  cout<<"<"<<$1<<">"<<" "<<"->"<<" "<<$3<<endl;
}
;

comparison:
  UPPERCASE GRT RULEOP rhs CB
  {
    cout<<"missing < symbol in: "<<linenum<<endl;
    errorFlag=true;
  }
  |
  LETTER GRT RULEOP rhs CB
  {
  	cout<<"missing < symbol in: "<<linenum<<endl;
  	errorFlag=true;
  }
  |
  LESS UPPERCASE RULEOP rhs CB
  {
    cout<<"missing > symbol in: "<<linenum<<endl;
    errorFlag=true;
  }
  |
  LESS LETTER RULEOP rhs CB
  {
    cout<<"missing > symbol in: "<<linenum<<endl;
    errorFlag=true;
  }
  ;

rhs:
LOWERCASE UPPERCASE rhs
{
sprintf($$, "%s%s%s", $1, $2, $3);
}
|
UPPERCASE LOWERCASE rhs
{
sprintf($$, "%s%s%s", $1, $2, $3);
}
|
LOWERCASE LESS UPPERCASE GRT rhs
{
sprintf($$, "%s%s", $1, $3);
string combined = string($1),string($3);
$$ = strdup(combined.c_str());
}
|
LESS UPPERCASE GRT LOWERCASE rhs
{
sprintf($$, "%s%s", $2, $4);
string combined = string($2),string($4);
$$ = strdup(combined.c_str());
}
|
LESS UPPERCASE GRT rhs
{
sprintf($$, "%s%s", $2, $4);
string combined = string($2),string($4);
$$ = strdup(combined.c_str());
}
|
LOWERCASE rhs
{
sprintf($$, "%s%s", $1, $2);
string combined = string($1),string($2);
$$ = strdup(combined.c_str());
}
|
LOWERCASE
{
$$ = strdup($1);
}
|
LESS UPPERCASE GRT
{
$$ = strdup($2);
}
;

lhss:
lhss lhs
|
lhs
;

lhs:
valuel {$$ = strdup($1);}
;

valuel:
LESS UPPERCASE GRT
 {$$=strdup($2);}
|
LESS LETTER GRT
 {$$=strdup($2);}
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
