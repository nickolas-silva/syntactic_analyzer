%{
#include <iostream>
using std::cout;

int yylex(void);
int yyparse(void);
void yyerror(const char *);
int error_count = 0;
%}

%token CLASS KEYWORD PROP NUM SYMBOL TYPE INDIVIDUAL KEYWORD_CLASS KEYWORD_EQUIVALENTTO KEYWORD_SUBCLASSOF KEYWORD_DISJOINTCLASSES KEYWORD_INDIVIDUALS ABRE_CHAVE FECHA_CHAVE ABRE_COLCHETES FECHA_COLCHETES VIRGULA ABRE_PARENTESES FECHA_PARENTESES QUANTIFIER INVALID

%%

stmnt: stmnt class
	 | class      
	 ;

class: class KEYWORD_CLASS CLASS body
	 | KEYWORD_CLASS CLASS body 
     ;

body: KEYWORD_EQUIVALENTTO ABRE_CHAVE acept_individual FECHA_CHAVE {cout<<"C ENUMERADA"<<"\n";} //Classe Enumerada ok 
	 | KEYWORD_SUBCLASSOF body_prop KEYWORD_DISJOINTCLASSES acept_class KEYWORD_INDIVIDUALS acept_individual {cout<<"C PRIMITIVA"<<"\n";}	//Classe Primitiva ok
	 | body_equivalent KEYWORD_INDIVIDUALS acept_individual {cout<<"C DEFINIDA"<<"\n";}
	 | KEYWORD_EQUIVALENTTO CLASS KEYWORD ABRE_PARENTESES body_prop param FECHA_PARENTESES	{cout<<"C DEFINIDA"<<"\n";}	//Classe Definida ok
	 | KEYWORD_EQUIVALENTTO class_or_class 	{cout<<"C COBERTA"<<"\n";}	//Classe Coberta ok
	 | KEYWORD_SUBCLASSOF CLASS VIRGULA body_prop {cout<<"C AXIO DE FECHAMENTO"<<"\n";}	//Axioma de fechamento ok
	 | KEYWORD_EQUIVALENTTO CLASS KEYWORD aux {cout<<"C DESCRICAO ANINHADA"<<"\n";}	//Descrições Aninhadas
	;
aux: ABRE_PARENTESES body_prop FECHA_PARENTESES aux
	 | ABRE_PARENTESES body_prop FECHA_PARENTESES
	 | KEYWORD ABRE_PARENTESES body_prop FECHA_PARENTESES aux
	 | KEYWORD ABRE_PARENTESES body_prop FECHA_PARENTESES
	 ;

body_equivalent: KEYWORD_EQUIVALENTTO CLASS KEYWORD ABRE_PARENTESES body_prop FECHA_PARENTESES
;

class_or_class: CLASS KEYWORD class_or_class
	 | CLASS
	 ;

param:  ABRE_COLCHETES SYMBOL NUM FECHA_COLCHETES
	;

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
	cout << "Errors Found = "<< error_count<< "\n";
}

void yyerror(const char * s)
{
	extern int yylineno;    
	extern char * yytext;   

	error_count++;
    cout << "Syntax Error: "<< yytext <<", line " << yylineno << "\n";
}