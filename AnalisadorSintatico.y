%{
    #include <stdio.h>
    #include <stdlib.h>
    #include <string.h>
    #include <math.h>
    #include "AnalisadorSintatico.h"

    void yyerror(const char *str)
    {
        fprintf(stderr, "error: %s\n", str);
    }

    int yywrap()    { return 1; }
    int main()      { yyparse(); }
%}

%union {
    No *pont;
}


%token <pont> FUNCTION
%token <pont> IF
%token <pont> INTEIRO
%token <pont> REAL

%token <pont> WHILE
%token <pont> VARIAVEL
%token <pont> CARACTERE

%token <pont> ESCREVA
%token <pont> LEIA
%token <pont> ABREC
%token <pont> FECHAC
%token <pont> ABREP
%token <pont> FECHAP
%token <pont> PIPE
%token <pont> SEND
%token <pont> FIMCOMANDO

%token <pont> TIPOINT
%token <pont> TIPOREAL
%token <pont> TIPOCARACTERE

%token <pont> OPLOGICO
%token <pont> OPNEGACAO
%token <pont> OPCOMPARACAO
%token <pont> OPMENORIGUAL
%token <pont> OPMAIORIGUAL
%token <pont> OPMENOR
%token <pont> OPMAIOR
%token <pont> OPDIFERENTE


%type <pont> S
%type <pont> tipo
%type <pont> param
%type <pont> corpo
%type <pont> declaracao
%type <pont> algoritmo
%type <pont> aritmetica
%type <pont> expressao
%type <pont> condicional
%type <pont> repeticao
%type <pont> compara
%type <pont> comp
%type <pont> entrada
%type <pont> saida
%type <pont> retorna

%right OPATRIBUICAO
%left OPSUBTRACAO OPSOMA
%left OPMULTIPLICACAO OPDIVISAO
%left OPMOD


%%

    S: FUNCTION tipo var ABREP param FECHAP ABREC corpo retorna FECHAC

    var: VARIAVEL                                  /* Thaty tá certo isso daqui??!?! AJUDA NOISZ */
        {
            $$ = (No*)malloc(sizeof(No));
            $$->token = VARIAVEL;
            strcpy($$->nome, yylval.pont->nome);
            $$->esq = NULL;
            $$->dir = NULL;
        }

    tipo: TIPOINT                                  /* Thaty tá certo isso daqui??!?! AJUDA NOISZ */
         {
            $$ = (No*)malloc(sizeof(No));
            $$->token = TIPOINT;
            strcpy($$->nome, yylval.pont->nome);
            $$->esq = NULL;
            $$->dir = NULL;
         }
         | TIPOREAL                                  /* Thaty tá certo isso daqui??!?! AJUDA NOISZ */
         {
            $$ = (No*)malloc(sizeof(No));
            $$->token = TIPOREAL;
            strcpy($$->nome, yylval.pont->nome);
            $$->esq = NULL;
            $$->dir = NULL;
         }
         | TIPOCARACTERE                                  /* Thaty tá certo isso daqui??!?! AJUDA NOISZ */
         {
            $$ = (No*)malloc(sizeof(No));
            $$->token = TIPOCARACTERE;
            strcpy($$->nome, yylval.pont->nome);
            $$->esq = NULL;
            $$->dir = NULL;
         }
    
    param:
          | tipo var
          | PIPE

    corpo: declaracao
          | algoritmo

    declaracao: tipo var FIMCOMANDO

    algoritmo: 
              | aritmetica
              | condicional
              | repeticao
              | entrada
              | saida

    aritmetica: var OPATRIBUICAO expressao FIMCOMANDO         /* DÚVIDA Código FimComando */
    {
        $$ = (No*)malloc(sizeof(No));
        $$->token = OPATRIBUICAO;
        strcpy($$->nome, yylval.pont->nome);
        $$->esq = $1;
        $$->dir = $3;
    }

    expressao: var
              | INTEIRO
              {
                  $$ = (No*)malloc(sizeof(No));
                  $$->token = INTEIRO;
                  $$->val = yylval.pont->val;
                  $$->esq = NULL;
                  $$->dir = NULL;    
              }
              | REAL
              {
                  $$ = (No*)malloc(sizeof(No));            /* Thaty tá certo isso daqui??!?! AJUDA NOISZ */
                  $$->token = REAL;                        /* Não temos certeza se 'val' de yylval.pont retorna */
                  $$->val = yylval.pont->val;              /* números reais também */
                  $$->esq = NULL;
                  $$->dir = NULL;
              }
              | expressao OPSOMA expressao
              {
                  $$ = (No*)malloc(sizeof(No));
                  $$->token = OPSOMA;
                  strcpy($$->nome, yylval.pont->nome);    // Por que a gente colocou isso aqui mesmo? ctr+c ctrl+v ?
                  $$->esq = $1;
                  $$->dir = $3;
              }
              | expressao OPSUBTRACAO expressao
              {
                  $$ = (No*)malloc(sizeof(No));
                  $$->token = OPSUBTRACAO;
                  strcpy($$->nome, yylval.pont->nome);
                  $$->esq = $1;
                  $$->dir = $3;
              }
              | expressao OPMULTIPLICACAO expressao
              {
                  $$ = (No*)malloc(sizeof(No));
                  $$->token = OPMULTIPLICACAO;
                  strcpy($$->nome, yylval.pont->nome);
                  $$->esq = $1;
                  $$->dir = $3;
              }
              | expressao OPDIVISAO expressao
              {
                  $$ = (No*)malloc(sizeof(No));
                  $$->token = OPDIVISAO;
                  strcpy($$->nome, yylval.pont->nome);
                  $$->esq = $1;
                  $$->dir = $3;
              }
              | expressao OPMOD expressao
              {
                  $$ = (No*)malloc(sizeof(No));
                  $$->token = OPMOD;
                  strcpy($$->nome, yylval.pont->nome);
                  $$->esq = $1;
                  $$->dir = $3;
              }
              | ABREP expressao FECHAP             /* Thaty tá certo isso daqui??!?! AJUDA NOISZ */
              {
                  $$ = (No*)malloc(sizeof(No));
                  $$ = $2;
              }

    condicional: IF ABREP compara FECHAP ABREC algoritmo FECHAC
                {
                    $$ = (No*)malloc(sizeof(No));
                    $$->token = IF;
                    $$->lookahead = $3;
                    $$->esq = $6;
                    $$->dir = NULL;
                }
                | IF ABREP expressao FECHAP ABREC algoritmo FECHAC
                {
                    $$ = (No*)malloc(sizeof(No));
                    $$->token = IF;
                    $$->lookahead = $3;
                    $$->esq = $6;
                    $$->dir = NULL;
                }

    repeticao: WHILE ABREP compara FECHAP ABREC algoritmo FECHAC
               {
                   $$ = (No*)malloc(sizeof(No));
                   $$->token = WHILE;
                   $$->lookahead = $3;
                   $$->esq = $6;
                   $$->dir = NULL;
                }

    compara: 
            | var OPCOMPARACAO var
            {
                $$ = (No*)malloc(sizeof(No));
                $$->token = OPCOMPARACAO;
                $$->esq = $1;
                $$->dir = $3;
            }
            | var OPMENORIGUAL var
            {
                $$ = (No*)malloc(sizeof(No));
                $$->token = OPMENORIGUAL;
                $$->esq = $1;
                $$->dir = $3;
            }
            | var OPMAIORIGUAL var
            {
                $$ = (No*)malloc(sizeof(No));
                $$->token = OPMAIORIGUAL
                $$->esq = $1;
                $$->dir = $3;
            }
            | var OPMENOR var
            {
                $$ = (No*)malloc(sizeof(No));
                $$->token = OPMENOR;
                $$->esq = $1;
                $$->dir = $3;
            }
            | var OPMAIOR var
            {
                $$ = (No*)malloc(sizeof(No));
                $$->token = OPMAIOR;
                $$->esq = $1;
                $$->dir = $3;
            }
            | var OPDIFERENTE var
            {
                $$ = (No*)malloc(sizeof(No));
                $$->token = OPDIFERENTE;
                $$->esq = $1;
                $$->dir = $3;
            }
            | expressao OPLOGICO expressao
            {
                $$ = (No*)malloc(sizeof(No));
                $$->token = OPLOGICO;
                $$->esq = $1;
                $$->dir = $3;
            }
            | OPNEGACAO var
            {
                $$ = (No*)malloc(sizeof(No));
                $$->token = OPNEGACAO;
                $$->esq = NULL;
                $$->dir = $2;
            }
            | PIPE

    entrada: LEIA var FIMCOMANDO

    saida: var ESCREVA FIMCOMANDO

    retorna: 
            | SEND var
            {
                $$ = (No*)malloc(sizeof(No));
                $$->token = SEND;
                $$->esq = NULL;
                $$->dir = $2;
            }
            | SEND expressao
            {
                $$ = (No*)malloc(sizeof(No));
                $$->token = SEND;
                $$->esq = NULL;
                $$->dir = $2;

            }
            | SEND CARACTERE    

%%
