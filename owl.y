%{
#include <iostream>
using std::cout;

int yylex(void);
int yyparse(void);
void yyerror(const char *);
%}

%token CLASS KEYWORD PROP NUM SYMBOL TYPE INDIVIDUAL KEYWORD_CLASS KEYWORD_EQUIVALENTTO KEYWORD_SUBCLASSOF KEYWORD_DISJOINTCLASSES KEYWORD_INDIVIDUALS ABRE_CHAVE FECHA_CHAVE ABRE_COLCHETES FECHA_COLCHETES VIRGULA ABRE_PARENTESES FECHA_PARENTESES QUANTIFIER


%%

stmnt: stmnt class
	 | class		     
	 ;

class: class KEYWORD_CLASS CLASS body
	 | KEYWORD_CLASS CLASS body
     ;

body: KEYWORD_EQUIVALENTTO ABRE_CHAVE acept_individual FECHA_CHAVE //Classe Enumerada ok
	 | KEYWORD_SUBCLASSOF body_prop KEYWORD_DISJOINTCLASSES acept_class KEYWORD_INDIVIDUALS acept_individual	//Classe Primitiva ok
	 | body_equivalent KEYWORD_INDIVIDUALS acept_individual KEYWORD_CLASS CLASS KEYWORD_EQUIVALENTTO CLASS KEYWORD ABRE_PARENTESES body_prop param FECHA_PARENTESES		//Classe Definida ok
	 | KEYWORD_EQUIVALENTTO class_or_class		//Classe Coberta ok
	 | KEYWORD_SUBCLASSOF CLASS VIRGULA body_prop	//Axioma de fechamento ok
	 | KEYWORD_EQUIVALENTTO CLASS KEYWORD aux	//Descrições Aninhadas
    ;
aux: ABRE_PARENTESES body_prop FECHA_PARENTESES aux
	 | ABRE_PARENTESES body_prop FECHA_PARENTESES
	 | KEYWORD ABRE_PARENTESES body_prop FECHA_PARENTESES aux
	 | KEYWORD ABRE_PARENTESES body_prop FECHA_PARENTESES
	 ;

body_equivalent: KEYWORD_EQUIVALENTTO CLASS KEYWORD ABRE_PARENTESES body_prop FECHA_PARENTESES

class_or_class: CLASS KEYWORD class_or_class
	 | CLASS
	 ;

param:  ABRE_COLCHETES SYMBOL NUM FECHA_COLCHETES

body_prop: PROP KEYWORD CLASS VIRGULA body_prop
	 | PROP KEYWORD TYPE
	 | PROP KEYWORD CLASS
	 | PROP KEYWORD ABRE_PARENTESES class_or_class FECHA_PARENTESES VIRGULA
	 | PROP KEYWORD ABRE_PARENTESES class_or_class FECHA_PARENTESES
	 | PROP QUANTIFIER CLASS VIRGULA body_prop
	 | PROP QUANTIFIER CLASS
	 | PROP QUANTIFIER TYPE
	 | PROP QUANTIFIER ABRE_PARENTESES class_or_class FECHA_PARENTESES
	 | PROP QUANTIFIER body_prop
	 | ABRE_PARENTESES body_prop FECHA_PARENTESES
	 | ABRE_PARENTESES body_prop FECHA_PARENTESES KEYWORD body_prop
	 ;

acept_class: CLASS VIRGULA acept_class
	 | CLASS
	 ;

acept_individual: INDIVIDUAL VIRGULA acept_individual
	 | INDIVIDUAL
	 ;

/* enumeraveis: enumeraveis VIRGULA enumeraveis
        | CLASS
        ; */



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