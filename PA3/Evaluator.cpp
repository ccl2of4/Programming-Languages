
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

	if(b->get_unop_type() == PRINT) {
		if(eval_e->get_type() == AST_STRING) {
			AstString* s = static_cast<AstString*>(eval_e);
			cout << s->get_string() << endl;
		}
		else cout << eval_e->to_value() << endl;
		return AstInt::make(0);

	}

      //add code to deal with all the other unops
      assert(false);

}

Expression* Evaluator::eval_binop(AstBinOp* b)
{
	Expression* e1 = b->get_first();
	Expression* e2 = b->get_second();
	Expression* eval_e1 = eval(e1);
	Expression* eval_e2 = eval(e2);
	bool error = false;
	switch(b->get_binop_type())
	{

	case PLUS:
	{
		if( eval_e1->get_type()== AST_INT && eval_e2->get_type() == AST_INT )
		{
			int i1 =  static_cast<AstInt *>(eval_e1)->get_int();
			int i2 =  static_cast<AstInt *>(eval_e2)->get_int();
			return AstInt::make(i1+i2);
		}
		else if(eval_e1->get_type()== AST_STRING && eval_e2->get_type() == AST_STRING )
		{
			string s1 =  static_cast<AstString *>(eval_e1)->get_string();
			string s2 =  static_cast<AstString *>(eval_e2)->get_string();
			return AstString::make(s1+s2);
		}
		else
		{
			error = true;			
		}
		break;
	}/*
	case MINUS
	{
		if( eval_e1->get_type()== AST_INT && eval_e2->get_type() == AST_INT )
		{
			int i1 =  static_cast<AstInt>(eval_e1).get_int();
			int i2 =  static_cast<AstInt>(eval_e2).get_int();
			return AstInt::make(i1-i2)
		}
		else
		{
			error = true;			
		}
		break;
	}
	case TIMES
	{
		if( eval_e1->get_type()== AST_INT && eval_e2->get_type() == AST_INT )
		{
			int i1 =  static_cast<AstInt>(eval_e1).get_int();
			int i2 =  static_cast<AstInt>(eval_e2).get_int();
			return AstInt::make(i1*i2)
		}
		else
		{
			error = true;			
		}
		break;
	}
	case DIVIDE
	{
	if( eval_e1->get_type()== AST_INT && eval_e2->get_type() == AST_INT )
		{
			int i1 =  static_cast<AstInt>(eval_e1).get_int();
			int i2 =  static_cast<AstInt>(eval_e2).get_int();
			return AstInt::make(i1-i2)
		}
		else
		{
			error = true;			
		}
		break;
	}
	case AND
	case OR
	case EQ
	case NEQ
	case LT
	case LEQ
	case GT
	case GEQ
	case CONS*/
	default:break;
	}
	if(error)
	{
		/*string type1 AstBinOp::binop_type_to_string(eval_e1->get_type());
		string type2 AstBinOp::binop_type_to_string(eval_e2->get_type());
		string op 
		report_error(b, )*/
	}
	return 0;
}






Expression* Evaluator::eval(Expression* e)
{


	Expression* res_exp = NULL;
	switch(e->get_type())
	{
	
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
			return AstInt::make(string_to_int(input));
		}
		return AstString::make(input);


		break;
	}
	case AST_INT:
	{
		res_exp = e;
		break;
	}
	case AST_BINOP:
	{
		AstBinOp* b = static_cast<AstBinOp*>(e);
		res_exp = eval_binop(b);
		break;
	}
	//ADD CASES FOR ALL EXPRESSIONS!!
	default:
		assert(false);


	}
	return res_exp;
}
