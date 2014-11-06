
#include "Evaluator.h"

#include "ast/expression.h"





/*
 * This skeleton currently only contains code to handle integer constants, print and read. 
 * It is your job to handle all of the rest of the L language.
 */





/*
 * Call this function to report any run-time errors
 * This will abort execution.
 */
void report_error(Expression* e, const string & s)
{
	cout << "Run-time error in expression " << e->to_value() << endl;
	cout << s << endl;
	exit(1);

}

Evaluator::Evaluator()
{
	sym_tab.push();
	c = 0;

}

Expression* Evaluator::eval_unop(AstUnOp* b)
{
	Expression* e = b->get_expression();
	Expression* eval_e = eval(e);
	Expression *res_exp = NULL;

	switch(b->get_unop_type())
	{
		case PRINT:
		{
			if(eval_e->get_type() == AST_STRING) {
				AstString* s = static_cast<AstString*>(eval_e);
				cout << s->get_string() << endl;
			}
			else {
				cout << eval_e->to_value() << endl;
			}
			res_exp = AstInt::make(0);
			break;
		}
		case ISNIL:
		{
			res_exp = AstInt::make(eval_e->get_type()==AST_NIL);
			break;
		}
		case HD:
		{
			if (eval_e->get_type() == AST_LIST) {
				res_exp = static_cast<AstList*>(eval_e)->get_hd();
			}
			else {
				res_exp = eval_e;
			}
			break;
		}
		case TL:
		{
			if (eval_e->get_type() == AST_LIST) {
				res_exp = static_cast<AstList*>(eval_e)->get_tl();
			}
			else {
				res_exp = AstNil::make();
			}
			break;
		}
		default: assert(false);
	}
	return res_exp;
}

Expression* Evaluator::eval_binop(AstBinOp* b)
{
	Expression* e1 = b->get_first();
	Expression* e2 = b->get_second();
	Expression* eval_e1 = eval(e1);
	Expression* eval_e2 = eval(e2);
	Expression* res_exp = NULL;

	if (b->get_binop_type() != CONS &&
		(eval_e1->get_type() == AST_LIST || eval_e2->get_type() == AST_LIST))
			report_error (b, "Binop @ is the only legal binop for lists");

	if (b->get_binop_type() != CONS &&
		(eval_e1->get_type() != eval_e2->get_type())) {
		report_error(b, "Binop can only be applied to expressions of the same type");
	}

	switch(b->get_binop_type())
	{
		case PLUS:
		{
			if(eval_e1->get_type()== AST_INT) {
				int i1 =  static_cast<AstInt *>(eval_e1)->get_int();
				int i2 =  static_cast<AstInt *>(eval_e2)->get_int();
				res_exp = AstInt::make(i1+i2);
			}
			else if(eval_e1->get_type()== AST_STRING ) {
				string s1 =  static_cast<AstString *>(eval_e1)->get_string();
				string s2 =  static_cast<AstString *>(eval_e2)->get_string();
				res_exp = AstString::make(s1+s2);
			}
			else assert(false);
			break;
		}
		case MINUS:
		{
			if (eval_e1->get_type() == AST_INT) {
				int i1 =  static_cast<AstInt *>(eval_e1)->get_int();
				int i2 =  static_cast<AstInt *>(eval_e2)->get_int();
				res_exp = AstInt::make(i1-i2);
			}
			else if (eval_e1->get_type() == AST_STRING) {
				report_error(b, "Binop - cannot be applied to strings");
			}
			else assert(false);
			break;
		}
		case TIMES:
		{
			if (eval_e1->get_type() == AST_INT) {
				int i1 =  static_cast<AstInt *>(eval_e1)->get_int();
				int i2 =  static_cast<AstInt *>(eval_e2)->get_int();
				res_exp = AstInt::make(i1*i2);
			}
			else if (eval_e1->get_type() == AST_STRING) {
				report_error(b, "Binop * cannot be applied to strings");
			}
			else assert(false);	
			break;
		}
		case DIVIDE:
		{
			if (eval_e1->get_type() == AST_INT) {
				int i1 =  static_cast<AstInt *>(eval_e1)->get_int();
				int i2 =  static_cast<AstInt *>(eval_e2)->get_int();
				res_exp = AstInt::make(i1/i2);
			}
			else if (eval_e1->get_type() == AST_STRING) {
				report_error(b, "Binop / cannot be applied to strings");
			}
			else assert(false);
			break;
		}
		case EQ:
		{
			if(eval_e1->get_type()== AST_INT) {
				int i1 =  static_cast<AstInt *>(eval_e1)->get_int();
				int i2 =  static_cast<AstInt *>(eval_e2)->get_int();
				res_exp = AstInt::make(i1==i2);
			}
			else if(eval_e1->get_type()== AST_STRING ) {
				string s1 =  static_cast<AstString *>(eval_e1)->get_string();
				string s2 =  static_cast<AstString *>(eval_e2)->get_string();
				res_exp = AstInt::make(s1==s2);
			}
			else assert(false);
			break;	
		}
		case NEQ:
		{
			if(eval_e1->get_type()== AST_INT) {
				int i1 =  static_cast<AstInt *>(eval_e1)->get_int();
				int i2 =  static_cast<AstInt *>(eval_e2)->get_int();
				res_exp = AstInt::make(i1!=i2);
			}
			else if(eval_e1->get_type()== AST_STRING ) {
				string s1 =  static_cast<AstString *>(eval_e1)->get_string();
				string s2 =  static_cast<AstString *>(eval_e2)->get_string();
				res_exp = AstInt::make(s1!=s2);
			}
			else assert(false);
			break;			
		}
		case LT:
		{
			if(eval_e1->get_type()== AST_INT) {
				int i1 =  static_cast<AstInt *>(eval_e1)->get_int();
				int i2 =  static_cast<AstInt *>(eval_e2)->get_int();
				res_exp = AstInt::make(i1<i2);
			}
			else if(eval_e1->get_type()== AST_STRING ) {
				report_error(b, "Binop < cannot be applied to strings");
			}
			else assert(false);
			break;	
		}
		case LEQ:
		{
			if(eval_e1->get_type()== AST_INT) {
				int i1 =  static_cast<AstInt *>(eval_e1)->get_int();
				int i2 =  static_cast<AstInt *>(eval_e2)->get_int();
				res_exp = AstInt::make(i1<=i2);
			}
			else if(eval_e1->get_type()== AST_STRING ) {
				report_error(b, "Binop <= cannot be applied to strings");
			}
			else assert(false);
			break;	
		}
		case GT:
		{
			if(eval_e1->get_type()== AST_INT) {
				int i1 =  static_cast<AstInt *>(eval_e1)->get_int();
				int i2 =  static_cast<AstInt *>(eval_e2)->get_int();
				res_exp = AstInt::make(i1>i2);
			}
			else if(eval_e1->get_type()== AST_STRING ) {
				report_error(b, "Binop > cannot be applied to strings");
			}
			else assert(false);
			break;	
		}
		case GEQ:
		{
			if(eval_e1->get_type()== AST_INT) {
				int i1 =  static_cast<AstInt *>(eval_e1)->get_int();
				int i2 =  static_cast<AstInt *>(eval_e2)->get_int();
				res_exp = AstInt::make(i1>=i2);
			}
			else if(eval_e1->get_type()== AST_STRING ) {
				report_error(b, "Binop >= cannot be applied to strings");
			}
			else assert(false);
			break;	
		}
		case AND:
		{
			if (eval_e1->get_type() == AST_INT) {
				int i1 =  static_cast<AstInt *>(eval_e1)->get_int();
				int i2 =  static_cast<AstInt *>(eval_e2)->get_int();
				res_exp = AstInt::make(i1&&i2);
			}
			else if (eval_e1->get_type() == AST_STRING) {
				report_error(b, "Binop & cannot be applied to strings");
			}
			else assert(false);
			break;
		}
		case OR:
		{
			if (eval_e1->get_type() == AST_INT) {
				int i1 =  static_cast<AstInt *>(eval_e1)->get_int();
				int i2 =  static_cast<AstInt *>(eval_e2)->get_int();
				res_exp = AstInt::make(i1||i2);
			}
			else if (eval_e1->get_type() == AST_STRING) {
				report_error(b, "Binop | cannot be applied to strings");
			}
			else assert(false);
			break;
		}
		case CONS:
		{
			if (eval_e2->get_type() != AST_NIL) {
				res_exp = AstList::make(eval_e1, eval_e2);
			} else {
				res_exp = eval_e1;
			}
			break;
		}
		default:assert(false);
	}
	return res_exp;
}

Expression* Evaluator::eval(Expression* e)
{
	Expression* res_exp = NULL;
	switch(e->get_type())
	{
		case AST_INT:
		{
			res_exp = e;
			break;
		}
		case AST_STRING:
		{
			res_exp = e;
			break;
		}
		case AST_NIL:
		{
			res_exp = e;
			break;
		}
		case AST_IDENTIFIER:
		{
			AstIdentifier *id = static_cast<AstIdentifier*>(e);
			if( !(res_exp = sym_tab.find(id)) )
					report_error(e, "Identifier ID is not bound in current context");
			break;
		}
		case AST_LET:
		{
			AstLet* l = static_cast<AstLet*>(e);
			Expression *e1 = l->get_val();
			Expression *e2 = l->get_body();
			Expression *eval_e1 = eval(e1);

			sym_tab.push();
			sym_tab.add(l->get_id(), eval_e1);
			Expression *eval_e2 = eval(e2);
			sym_tab.pop();

			res_exp = eval_e2;
			break;
		}
		case AST_BRANCH:
		{
			AstBranch *b = static_cast<AstBranch*>(e);
			Expression *p = b->get_pred();
			Expression *e1 = b->get_then_exp();
			Expression *e2 = b->get_else_exp();

			Expression *p_eval = eval(p);
			if (p_eval->get_type() == AST_INT) {
				int p_i = static_cast<AstInt*>(p_eval)->get_int();
				if (p_i) {
					Expression *e1_eval = eval(e1);
					res_exp = e1_eval;
				} else {
					Expression *e2_eval = eval(e2);
					res_exp = e2_eval;
				}
			} else {
				report_error(e, "Predicate in conditional must be an integer");
			}
			break;
		}
		case AST_LAMBDA:
		{
			res_exp = e;
			break;
		}
		case AST_EXPRESSION_LIST:
		{
			AstExpressionList *l = static_cast<AstExpressionList*>(e);
			const vector<Expression*>& expressions = l->get_expressions();
			assert(expressions.size());
			Expression *e1 = expressions[0];

			if (expressions.size() == 1) {
				res_exp = e1;
			}
			else {
				Expression *e2 = expressions[1];
				Expression *eval_e1 = eval(e1);
				if (eval_e1->get_type() == AST_LAMBDA) {
					AstLambda *l = static_cast<AstLambda*>(eval_e1);
					AstIdentifier *id = l->get_formal();
					Expression *new_body = l->get_body()->substitute(id,e2);
					Expression *eval_e1_p = eval(new_body);
					AstExpressionList *list = AstExpressionList::make(eval_e1_p);
					for (unsigned i = 2; i < expressions.size(); ++i) {
						list = list->append_exp(expressions[i]);
					}
					res_exp = eval(list);
				}
				else {
					report_error(e, "Only lambda expressions can be applied to other expressions");
				}
			}
			break;
		}
		case AST_BINOP:
		{
			AstBinOp* b = static_cast<AstBinOp*>(e);
			res_exp = eval_binop(b);
			break;
		}
		case AST_UNOP:
		{
			AstUnOp* b = static_cast<AstUnOp*>(e);
			res_exp = eval_unop(b);
			break;
		}
		case AST_READ:
		{
			AstRead* r = static_cast<AstRead*>(e);
			string input;
			getline(cin, input);
			if(r->read_integer()) {
				res_exp = AstInt::make(string_to_int(input));
			} else {
				res_exp = AstString::make(input);
			}
			break;
		}
		default: assert(false);
	}
	return res_exp;
}
