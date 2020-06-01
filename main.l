%{
	#include<stdio.h>
	#include <string.h>
	#include "main.tab.h"
	#include<stdlib.h>
%}

identifiers "variable_"[a-zA-Z0-9]+
unary_plus "#++"
unary_minus "#--"
integer [+-]?[0-9]+
float [+-]?[0-9]+[.][0-9]+|[+-]?[.][0-9]+|[1-9]+e[+-][0-9]+
double [+-]?[0-9]+[.][0-9]+{6,12}|[+-]?[.][0-9]+|[1-9]+e[+-][0-9]+{6,12}
char [A-Za-z]+
single_line_comment [/][/].*
multiple_line_comment [ ]*[/][a][/][a-zA-Z0-9!@#*(){}_+-,.:\|?><\n\t ]*[/][a][/]

/*RE and Action*/

%%


{single_line_comment} {
	printf("THIS IS SINGLE LINE COMMENT\n");

}
{multiple_line_comment} {
	printf("THIS IS MULTIPLE LINE COMMENT\n");
}

{unary_plus}   {return inc;}
{unary_minus}   {return dec;}
"{"	 { return LB; }
"}"	  { return RB; }
"break_loop"    {   return BREAK;     }
"case"      { return CASE;      }
"switch"      { return SWITCH;	}
"default"     {  return DEFAULT; 	}
"loop_while" { return WHILE;}
"intType"	{ return INT; }
"floatType"	{ return FLOAT; }
"doubleType"	{return DOUBLE;}
"charType"	{ return CHAR; }
":"     { return COL;}
{integer}	{ 
		yylval.number = atoi(yytext);
		return NUM;
	}
"loop_for"   { return FOR;}	
"("	{ return LP; }
")"	{ return RP; }
","	{ return CM; }
"!!"	{ return SM; }
"plus"	{ return PLUS;}
"minus"	{ return MINUS; }
"multiply"	{ return MULT; }
"divide"	{ return DIV; }
"pow"	{ return POW; }
"fact"	{ return FACT; }
"eq"		{ return ASSIGN;  }
"greater"	{ return GT; }
"less"	{ return LT; }
"lessoreq" {return LOE;}
"greateroreq" {return GOT;}
"sine"	{return SINE;}
"cos"	{return COS;}
"tan"	{return TAN;}
"cot"	{return COT;}
"ln"	{return LN;}

{identifiers} {
	 yylval.string=strdup(yytext);
	 return VAR;
	}

"if"		{ return IF;}
"else"		{ return ELSE;}
"elif"	{ return ELIF; }

"void function "[A-Za-z]+	{ return FUNCTION; }

[ \t\n]*	

.	{
		yyerror("Unknown Character.\n");
	}
%%

int main()
{
	yyin = freopen("input1.txt","r",stdin);
	yyout = freopen("output1.txt","w",stdout);
	yyparse();	
}