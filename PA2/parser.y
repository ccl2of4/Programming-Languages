%{
#include "parser-defs.h"

int yylex();
extern int yy_scan_string(const char* c);
int yyerror(const char* p)
{ 
  if(parser_error_fn != NULL) {
    parser_error_fn("At line " + int_to_string(curr_lineno) + ": " + string(p));
  }
  return 1;
};

 



%}
/* BISON Declarations */
%token 
TOKEN_READSTRING 
TOKEN_READINT 
TOKEN_PRINT 
TOKEN_ISNIL
TOKEN_HD 
TOKEN_TL 
TOKEN_CONS 
TOKEN_NIL 
TOKEN_DOT 
TOKEN_WITH 
TOKEN_LET 
TOKEN_PLUS 
TOKEN_MINUS 
TOKEN_IDENTIFIER 
TOKEN_TIMES 
TOKEN_DIVIDE 
TOKEN_INT 
TOKEN_LPAREN 
TOKEN_RPAREN 
TOKEN_AND 
TOKEN_OR 
TOKEN_EQ 
TOKEN_NEQ 
TOKEN_GT 
TOKEN_GEQ 
TOKEN_LT 
TOKEN_LEQ 
TOKEN_IF 
TOKEN_THEN 
TOKEN_ELSE 
TOKEN_LAMBDA 
TOKEN_FUN 
TOKEN_COMMA 
TOKEN_STRING 
TOKEN_ERROR 
TOKEN_IN



%nonassoc EXPR
%left TOKEN_PLUS
%left TOKEN_TIMES



%%







program: expression
{
	res_expr = $$;
}



expression: TOKEN_LET identifier TOKEN_EQ expression TOKEN_IN expression
{
  assert($2->get_type() == AST_IDENTIFIER);
  $$ = AstLet::make(
    static_cast<AstIdentifier*>($2),
    $4,
    $6
  );
}
|
TOKEN_FUN identifier TOKEN_WITH identifier_list TOKEN_EQ expression TOKEN_IN expression
{
  assert($2->get_type() == AST_IDENTIFIER);
  assert($4->get_type() == AST_IDENTIFIER_LIST);
  
  AstLambda *lambda_expr = AstLambda::make(
    static_cast<AstIdentifierList*>($4),
    $6
  );
  
  AstLet *let = AstLet::make(
    static_cast<AstIdentifier*>($2),
    lambda_expr,
    $8
  );

  $$ = let;
}
|
TOKEN_LAMBDA identifier_list TOKEN_DOT expression
{
  assert ($2->get_type() == AST_IDENTIFIER_LIST);
  AstIdentifierList *l = static_cast<AstIdentifierList*>($2);
  $$ = AstLambda::make(l, $4);
}
|
TOKEN_IF expression TOKEN_THEN expression TOKEN_ELSE expression %prec EXPR
{
  $$ = AstBranch::make($2, $4, $6);
}
|
expression TOKEN_PLUS expression 
{
  $$ = AstBinOp::make(PLUS, $1, $3);
}
|
expression TOKEN_AND expression
{
  $$ = AstBinOp::make(AND, $1, $3);
}
|
expression TOKEN_OR expression
{
  $$ = AstBinOp::make(OR, $1, $3);
}
|
expression TOKEN_MINUS expression 
{
  $$ = AstBinOp::make(MINUS, $1, $3);
}
|
expression TOKEN_TIMES expression 
{
  $$ = AstBinOp::make(TIMES, $1, $3);
}
|
expression TOKEN_DIVIDE expression 
{
  $$ = AstBinOp::make(DIVIDE, $1, $3);
}
|
expression TOKEN_EQ expression
{
  $$ = AstBinOp::make(EQ, $1, $3);
}
|
expression TOKEN_NEQ expression
{
  $$ = AstBinOp::make(NEQ, $1, $3);
}
|
expression TOKEN_LT expression
{
  $$ = AstBinOp::make(LT, $1, $3);
}
|
expression TOKEN_LEQ expression
{
  $$ = AstBinOp::make(LEQ, $1, $3);
}
|
expression TOKEN_GT expression
{
  $$ = AstBinOp::make(GT, $1, $3);
}
|
expression TOKEN_GEQ expression
{
  $$ = AstBinOp::make(GEQ, $1, $3);
}
|
TOKEN_INT 
{
  	string lexeme = GET_LEXEME($1);
  	long int val = string_to_int(lexeme);
  	Expression* e = AstInt::make(val);
  	$$ = e;
} 
|
TOKEN_STRING 
{
	string lexeme = GET_LEXEME($1);
  	Expression* e = AstString::make(lexeme);
  	$$ = e;
}
|
TOKEN_LPAREN expression_application TOKEN_RPAREN
{
  $$ = $2;
}
|
TOKEN_PRINT expression
{
  $$ = AstUnOp::make(PRINT, $2);
}
|
TOKEN_READINT
{
  $$ = AstRead::make(true);
}
|
TOKEN_READSTRING
{
  $$ = AstRead::make(false);
}
|
TOKEN_HD expression
{
  $$ = AstUnOp::make(HD, $2);
}
|
TOKEN_TL expression
{
  $$ = AstUnOp::make(TL, $2);
}
|
expression TOKEN_CONS expression
{
  $$ = AstBinOp::make(CONS, $1, $3);
}
|
TOKEN_NIL
{
  $$ = AstNil::make();
}
|
TOKEN_ISNIL expression
{
  $$ = AstUnOp::make(ISNIL, $2);
}
|
identifier
{
  $$ = $1;
}  
|
TOKEN_LPAREN expression TOKEN_RPAREN
{
	$$ = $2;
}
|
TOKEN_ERROR 
{
   // do not change the error rule
   string lexeme = GET_LEXEME($1);
   string error = "Lexing error: ";
   if(lexeme != "") error += lexeme;
   yyerror(error.c_str());
   YYERROR;
}



expression_application: expression expression
{
	AstExpressionList *l = AstExpressionList::make($1);
	l = l->append_exp($2);
	$$ = l;
}
|
expression_application expression
{
	Expression* _l = $1;
	assert(_l->get_type() == AST_EXPRESSION_LIST);
	AstExpressionList* l = static_cast<AstExpressionList*>(_l);
	$$ = l->append_exp($2);
}



identifier_list: identifier
{
  assert ($1->get_type() == AST_IDENTIFIER);
  $$ = AstIdentifierList::make(
    static_cast<AstIdentifier*>($1)
  );
}
|
identifier TOKEN_COMMA identifier_list
{
  assert($3->get_type() == AST_IDENTIFIER_LIST);
  assert($1->get_type() == AST_IDENTIFIER);
  AstIdentifierList *l = static_cast<AstIdentifierList*>$3;
  AstIdentifier *id = static_cast<AstIdentifier*>$1;
  l = l->append_id(id);
  $$ = l;
}

identifier: TOKEN_IDENTIFIER
{
  AstIdentifier *id = AstIdentifier::make(GET_LEXEME($1));
  $$ = id;
}