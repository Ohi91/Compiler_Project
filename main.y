%{
	#include<stdio.h>
	#include <math.h>
	int cnt=1,cnt3=1,val,num;
	typedef struct entry {
    	char *str;
    	int n;
	}storage;
	storage store[1000],symbol[1000];
	void insert (storage *p, char *s, int n);
	int cnt2=1; 
	#define pi  3.1416
	#define var 180
	int my_val, track = 0;
	
%}
%union 
{
        int number;
        char *string;
}
/* BISON Declarations */

%token <number> NUM
%token <string> VAR 
%token <string> IF ELIF ELSE FUNCTION INT FLOAT DOUBLE CHAR LP RP LB RB CM SM PLUS MINUS MULT DIV POW FACT ASSIGN FOR COL WHILE BREAK COLON DEFAULT CASE SWITCH inc dec LOE GOT SINE COS TAN COT LN
%type <string> statement
%type <number> expression
%type <number> expression_switch
%nonassoc IFX
%nonassoc ELSEX
%nonassoc ELIFX
%left LT GT
%left PLUS MINUS
%left MULT DIV
%left FACT
%left POW

%%

program: FUNCTION LP RP LB cstatement RB { printf("\nSuccessful compilation\n"); }
	 ;

cstatement: /* empty */

	| cstatement statement
	
	| cdeclaration
	;

cdeclaration:	TYPE ID1 SM	{ printf("\nvalid declaration\n"); }
   
			;
			
TYPE : INT

     | FLOAT

     | CHAR
     ;

ID1  : ID1 CM VAR	{
						if(number_for_key($3))
						{
							printf("\nWARNING: %s is already declared\n", $3 );
						}
						else
						{
							insert(&store[cnt],$3, cnt);
							cnt++;
							
						}
			}

     |VAR	{
				if(number_for_key($1))
				{
					printf("\nWARNING: %s is already declared\n", $1 );
				}
				else
				{
					insert(&store[cnt],$1, cnt);
							cnt++;
				}
			}
     ;

statement: SM
	| SWITCH LP expression_switch RP LB BASE RB    {printf("SWITCH CASE!!!!.\n");val=$3;}   

	| expression SM 			{ printf("\nvalue of expression: %d\n", ($1)); }

        | VAR ASSIGN expression SM 		{
							if(number_for_key($1)){
								int i = number_for_key2($1);
								if (!i){
									insert(&symbol[cnt3], $1, $3);
									printf("\n(%s) Value of the variable: %d\t\n",$1,$3);
									cnt3++;
								}else{
									symbol[i].n = $3;
									printf("\n(%s) Updated Value of the variable: %d\t\n",$1,$3);
								}
							}
							else {
								printf("\nWARNING: (%s) is not declared yet\n",$1);
							}
							
						}

	| IF LP expression RP LB expression SM RB %prec IFX {
								if($3)
								{
									printf("\nvalue of expression in IF: %d\n",($6));
								}
								else
								{
									printf("\nTHE CONDITION FOR IF IS FALSE\n");
								}
							}

	| IF LP expression RP LB expression SM RB ELSE LB expression SM RB %prec ELSEX{
								 	if($3)
									{
										printf("\nvalue of expression in IF: %d\n",$6);
									}
									else
									{
										printf("\nvalue of expression in ELSE: %d\n",$11);
									}
								   }
	| IF LP expression RP LB IF LP expression RP LB expression SM RB ELSE LB expression SM RB expression SM RB ELSE LB expression SM RB %prec IFX {
								 	if($3)
									{
										if($8)
											printf("\nvalue of expression middle IF: %d\n",$11);
										else
											printf("\nvalue of expression middle ELSE: %d\n",$16);
										printf("\nvalue of expression in first IF: %d\n",$19);
									}
									else
									{
										printf("\nvalue of expression in else: %d\n",$24);
									}
								   }
	| IF LP expression RP LB expression SM RB ELIF LP expression RP LB expression SM RB ELSE LB expression SM RB %prec ELIFX{
								 	if($3)
									{
										printf("\nvalue of expression in IF: %d\n",$6);
									}
									else if($11)
									{
										printf("\nvalue of expression in ELIF: %d\n",$14);
									}
									else
									{
										printf("\nvalue of expression in ELSE: %d\n",$19);
									}
								   }							   
	| FOR LP NUM COL NUM RP LB expression RB     {
	   int i=0;
	   for(i=$3;i<$5;i++){
	   printf("for loop %d statement\n : value is : %d\n",i, $8);
	   }
	}
	| WHILE LP NUM GT NUM RP LB expression RB   {
										int i;
										printf("While LOOP: ");
										for(i=$3;i<=$5;i++)
										{
											printf("value of the expression in while loop %d : %d\n",i,$8);
										}
										printf("\n");
										

	}
	;






	
			BASE : Base2  
				 | Base2 Default 
				 ;

			Base2   : /*NULL*/
				 | Base2 Cs     
				 ;

			Cs    : CASE NUM COL expression SM   {
								if (my_val == $2){
									track = 1;
									printf("\nCase No : %d  and Result :  %d\n",$2,$4);
								}							  
							  		
					}
				 ;

			Default    : DEFAULT COL NUM SM    {					
							if (track != 1){
								printf("\nResult in default Value is :  %d \n",$3);
							}
							track = 0;				
					}
				 ;    
expression_switch:	NUM				{ $$ = $1;	my_val = $1;}

	| VAR				{  int i = number_for_key2($1);  $$ = symbol[i].n; printf("Variable value: %d",$$)}

	| expression_switch PLUS expression_switch	{ $$ = $1 + $3; my_val = $$; }

	| expression_switch MINUS expression_switch	{ $$ = $1 - $3; my_val = $$; }

	| expression_switch MULT expression_switch	{ $$ = $1 * $3; my_val = $$; }

	| expression_switch DIV expression_switch	{ 	if($3) 
				  		{
				     			$$ = $1 / $3;
				     			my_val = $$;
				  		}
				  		else
				  		{
							$$ = 0;
							printf("\ndivision by zero\t");
							my_val = $$;
				  		} 	
				    	}
	| SINE '(' expression ')' { $$=sin($3 * pi / var);}
	| COS '(' expression ')' { $$=cos($3 *pi / var);}
	| TAN '(' expression ')' { $$=tan($3 *pi / var);}
	| LN '(' expression ')' { $$=log($3);}				    	
	| expression_switch POW expression_switch { $$ = pow($1,$3);my_val = $$; }

	| expression_switch FACT {
						int mult=1 ,i;
						for(i=$1;i>0;i--)
						{
							mult=mult*i;
						}
						$$=mult;
						my_val = $$;
						
					 }	
;






	
expression: NUM				{ $$ = $1; 	}

	| VAR				{  int i = number_for_key2($1);  $$ = symbol[i].n; printf("Variable value: %d",$$)}

	| expression PLUS expression	{ $$ = $1 + $3; }

	| expression MINUS expression	{ $$ = $1 - $3; }

	| expression MULT expression	{ $$ = $1 * $3; }

	| expression DIV expression	{ 	if($3) 
				  		{
				     			$$ = $1 / $3;
				  		}
				  		else
				  		{
							$$ = 0;
							printf("\ndivision by zero\t");
				  		} 	
				    	}
	| expression POW expression { $$ = pow($1,$3); }

	| expression FACT {
						int mult=1 ,i;
						for(i=$1;i>0;i--)
						{
							mult=mult*i;
						}
						$$=mult;
						
					 }	

	| expression LT expression	{ $$ = $1 < $3; }

	| expression GT expression	{ $$ = $1 > $3; }

	| LP expression RP		{ $$ = $2;	}
	
	| inc expression inc         { $$=$2+1; printf("After unary plus: %d\n",$$);}
	| dec expression dec         { $$=$2-1; printf("After unary minus: %d\n",$$);}	
	;
%%

void insert(storage *p, char *s, int n)
{
  p->str = s;
  p->n = n;
}

int number_for_key(char *key)
{
    int i = 1;
    char *name = store[i].str;
    while (name) {
        if (strcmp(name, key) == 0)
            return i;
        name = store[++i].str;
    }
    return 0;
}

int number_for_key2(char *key)
{
    int i = 1;
    char *name = symbol[i].str;
    while (name) {
        if (strcmp(name, key) == 0)
            return i;
        name = symbol[++i].str;
    }
    return 0;
}

int yywrap()
{
return 1;
}

yyerror(char *s){
	printf( "%s\n", s);
}