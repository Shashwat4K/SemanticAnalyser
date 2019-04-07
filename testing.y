%{
#include <bits/stdc++.h>
#define MAX_SIZE 100
typedef struct my_var
{
    int type;
    char* variable_name;

}MY_VAR;
//MY_VAR variable_array[MAX_SIZE]; Array of variables
std::vector<MY_VAR> variable_vector;
int my_index = 0;
void yyerror(char *s);
int yylex();

void setDataType(int t, char *var);
void displayVariables();
int getVariableType(char *x);
int isNumeric(char *s);
%}
%union {int a; char* c;}
%start begin
%token id numeric INT FLOAT CHAR INCLUDE MAIN VOID ARGCS
%left '+' '-'
%left '*' '/' '%'
%type <a> datatype INT FLOAT CHAR
%type <c> id numeric term exp
%%
begin : Headers MAIN '(' args ')' '{' line '}'           {printf("Parsing successful!\n"); displayVariables();}
     ;

Headers : '#' INCLUDE '<' header_name '>'            {printf("HEADER defined successfully\n");}
        | Headers '#' INCLUDE '<' header_name '>'    {printf("HEADER defined successfully\n");}
        ;

header_name : id '.' id
            ;
args : VOID 
     | ARGCS
     |
     ;
line : declaration ';'  {printf("variable declared successfully\n");}
     | line declaration ';' {printf("variable declared successfully\n");}
     | assignment ';'   {printf("Assignment\n");}
     | line assignment ';' {printf("Assignment\n");}
     | empty_program
     ;
empty_program : ;     
declaration : datatype id   { setDataType($1, $2); }
            ;
datatype : INT      {$$ = 1;}
         | FLOAT    {$$ = 2;}
         | CHAR     {$$ = 3;}
         ;                
assignment : id '=' exp
           ;
exp : exp '+' exp
    | exp '-' exp
    | exp '*' exp
    | exp '/' exp
    | exp '%' exp   
    | term          { 
                        if(!isNumeric($1) && !getVariableType($1)){ 
                            yyerror("Variable Not declared!\n");  
                        }else{
                            $$ = $1;
                        } 
                    }
    ;
term : id       {$$ = $1;}
     | numeric  {$$ = $1;}
     ;               
%%
int main(void)
{
    yyparse();
    return 0;
}
void setDataType(int t, char *var)
{

        MY_VAR mv;
        mv.type = t;
        mv.variable_name = new char[strlen(var) + 1];
        strcpy(mv.variable_name, var);
        variable_vector.push_back(mv);
        my_index++;
    
}
void displayVariables()
{

    std::vector<MY_VAR>::iterator j;
    for(j = variable_vector.begin(); j != variable_vector.end(); ++j)
    {
        switch((*j).type)
        {
            case 1: printf("Variable: %s type 'int'\n", (*j).variable_name); break;
            case 2: printf("Variable: %s type 'float'\n", (*j).variable_name); break;
            case 3: printf("Variable: %s type 'char'\n", (*j).variable_name); break;
        }
    }
}
int getVariableType(char *x)
{
    std::vector<MY_VAR>::iterator it;
    int flag = 0;
    for(it = variable_vector.begin(); it!=variable_vector.end(); ++it)
    {
        if(strcmp((*it).variable_name, x) == 0){
            flag = (*it).type;
            break;
        }
    }
    return flag;
}
int isNumeric(char *s)
{
    int flag = 1;
    int i;
    for(i = 0; i < strlen(s); i++)
    {
        if(s[i] < '0' || s[i] > '9'){
            flag = 0;
            break;
        }
    }
    return flag;
}
void yyerror(char *s){
    printf("ERROR: %s\n", s);
}