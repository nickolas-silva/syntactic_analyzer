%{
#include <iostream>
using std::cout;

int yylex(void);
int yyparse(void);
void yyerror(const char *);
%}

%token CLASS KEYWORD PROP NUM SYMBOL TYPE INDIVIDUAL KEYWORD_CLASS KEYWORD_EQUIVALENTTO ABRE_CHAVE FECHA_CHAVE VIRGULA

%%

stmnt: stmnt class
	 | class		     
	 ;

class: class KEYWORD_CLASS CLASS body
	 | KEYWORD_CLASS CLASS body
     ;

body: KEYWORD_EQUIVALENTTO ABRE_CHAVE enumeraveis FECHA_CHAVE
    ;

enumeraveis: enumeraveis VIRGULA enumeraveis
        | CLASS
        ;

%%

extern FILE * yyin;  

int main(int argc, char ** argv)
{
	if (argc > 1)
	{
		FILE * file;
		file = fopen(argv[1], "r");
		if (!file)
		{
			cout << "Arquivo " << argv[1] << " não encontrado!\n";
			exit(1);
		}
		
		yyin = file;
	}

	yyparse();
}

void yyerror(const char * s)
{
	extern int yylineno;    
	extern char * yytext;   

    cout << "Erro sintático: símbolo \"" << yytext << "\" (linha " << yylineno << ")\n";
}