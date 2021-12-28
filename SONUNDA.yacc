%{
  #include <stdio.h>
  #include <sstream>
  #include <iostream>
  #include <string>
  #include <map>
  #include <vector>
  #include <algorithm>
	using namespace std;
	#include "y.tab.h"
	extern FILE *yyin;
	extern int yylex();
	void yyerror(string s);
	bool errorFlag=false;
	extern int linenum;
	map<string,string> values;
  vector<string> leftv;
  vector<string> rightv;
  vector<string> tempv;


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
leftv.push_back(combinedl);
}
;

rhs:
TERMINALS
{
string combinedr = string($1);
$$ = strdup(combinedr.c_str());
rightv.push_back(combinedr);
}
|
NONTERMINALS
{
string combinedr = string($1);
$$ = strdup(combinedr.c_str());
rightv.push_back(combinedr);
}
|
NONTERMINALS TERMINALS
{
string combinedr = string($1) + " " +string($2);
$$ = strdup(combinedr.c_str());
rightv.push_back(combinedr);
}
|
TERMINALS TERMINALS
{
string combinedr = string($1) + " " +string($2);
$$ = strdup(combinedr.c_str());
rightv.push_back(combinedr);
}
|
TERMINALS NONTERMINALS
{
string combinedr = string($1) + " " +string($2);
$$ = strdup(combinedr.c_str());
rightv.push_back(combinedr);
}
|
TERMINALS NONTERMINALS TERMINALS
{
string combinedr = string($1) + " " +string($2) + " " + string($3);
$$ = strdup(combinedr.c_str());
rightv.push_back(combinedr);
}
|
TERMINALS TERMINALS TERMINALS
{
string combinedr = string($1) + " " +string($2) + " " + string($3);
$$ = strdup(combinedr.c_str());
rightv.push_back(combinedr);
}
|
NONTERMINALS TERMINALS NONTERMINALS
{
string combinedr = string($1) + " " +string($2) + " " + string($3);
$$ = strdup(combinedr.c_str());
rightv.push_back(combinedr);
}
|
NONTERMINALS NONTERMINALS NONTERMINALS
{
string combinedr = string($1) + " " +string($2) + " " + string($3);
$$ = strdup(combinedr.c_str());
rightv.push_back(combinedr);
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
		cout<<"***completed without an error. The output from left recursion algorithm:***"<<endl;

	   for (int i = 0; i < rightv.size(); i++)

    {
    string rightStr = rightv[i];
    string leftStr = leftv[i];
    size_t found = rightStr.find(leftStr);
    size_t found2 = leftStr.find(">");



    if(found!=std::string::npos)
    {
    if(found2!=std::string::npos)
    {
    string newNonterminal=leftStr.insert (2,"2");
     //cout<<"Apply Left Recursion:"<<endl;

     string temp = "";
   	for(int i=0;i<rightStr.length();i++){

   		if(rightStr[i]==' '){
   			tempv.push_back(temp);
   			temp = "";
   		}
   		else{
   			temp.push_back(rightStr[i]);
   		}

   	}
   	tempv.push_back(temp);
    cout<<leftStr<<" "<<"->"<<" "<<tempv[2]<<" "<<newNonterminal<<endl;
    cout<<newNonterminal<<" "<<"->"<<" "<<"epsilon"<<endl;



    }

    }
    else
    {
    	cout<<leftv[i]<<" "<<"->"<<" "<<rightv[i]<<endl;
    		}
    	}
        return 0;
    }
