%{

#include "owl.tab.h"

%}

%option yylineno
%option noyywrap

delim [ /t/n]
brancos {delim}+
maiusculas [A-Z]
minusculas [a-z]
letra [A-Za-z]
digito [0-9]
numero {digito}+

minusculas_sem_i [abcdefghjklmnopqrstuvxyz]
minusculas_sem_s [abcdefghijklmnopqrtuvxyz]

some "SOME"|"some"
value "VALUE"|"value"
all "ALL"|"all"
min "MIN"|"min"
max "MAX"|"max"
exactly "EXACTLY"|"exactly"
that "THAT"|"that"
not "NOT"|"not"
and "AND"|"and"
or "OR"|"or"

integer "integer"
namespaces ("owl"|"rdfs"|"xsd")":"({letra}+)
operators (">"|"<"|">="|"<=")

stringcomposta  {maiusculas}({letra})+
id              {stringcomposta}("_"?{stringcomposta})*
prop            "ssn"|("is"{stringcomposta}*"Of")|({minusculas_sem_i}{minusculas_sem_s}{minusculas}*({stringcomposta})*)
individuo       {id}({numero}+)

%%
[\t\n]+ ;
{some} |        
{value} |      
{all} |     
{min} |        
{max} |       
{exactly} |    
{that} |        
{not} |           
{and}         return KEYWORD;
{id}          return CLASS;
{prop}        return PROP;
{numero}      return NUM;
{operators}   return SYMBOL;
"{"           return ABRE_CHAVE;
"}"           return FECHA_CHAVE;
"("           return ABRE_PARENTESES;
")"           return FECHA_PARENTESES;
"["           return ABRE_COLCHETES;
"]"           return FECHA_COLCHETES;
","           return VIRGULA;
\"            return SYMBOL;
{integer}     return TYPE;
{namespaces}  return TYPE;
{individuo}   return INDIVIDUAL;
"Class:"      return KEYWORD_CLASS;
"EquivalentTo:" return KEYWORD_EQUIVALENTTO;
"SubClassOf:" return KEYWORD_SUBCLASSOF;
"DisjointClasses:" return KEYWORD_DISJOINTCLASSES;
"Individuals:" return KEYWORD_INDIVIDUALS;

%%
