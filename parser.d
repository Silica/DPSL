
import tokenizer;
import environment;
import code;

import std.stdio;

class Parser
{
	Tokenizer t;
	int error = 0;
	this(Tokenizer to)
	{
		t = to;
	}
	void Parse(Environment v)
	{
		while (t.checkNext())
			ParseStatement(v);
	}
	void ParseStatement(Environment v)
	{
		int n = t.checkNext();
		if (n == ';')
		{
			t.getNext();
			return;
		}
		ParseExpression(v, ';');
	}
	void ParseExpression(Environment c, char e, bool l = false)
	{
		getexp13(c, l);
		if (!t.getNextIf(e))
			writefln("error ;");
	}
	void getexp13(Environment c, bool l = false)
	{
		getexp2(c, l);
		while (t.checkNext())
		{
			int n = t.checkNext();
			if (n == '=')
			{
				t.getNext();
				getexp13(c, l);
				c.pushcode(new SUBSTITUTION);
			}
			else break;
		}
	}
	void getexp2(Environment c, bool l = false)
	{
		getexp1(c, l);
		while (t.checkNext())
		{
			int n = t.checkNext();
			if (n == '+')
			{
				t.getNext();
				getexp1(c, l);
				c.pushcode(new ADD);
			}
			else if (n == '-')
			{
				t.getNext();
				getexp1(c, l);
				c.pushcode(new SUB);
			}
			else break;
		}
	}
	void getexp1(Environment c, bool l = false)
	{
		getTerm(c);
		while (t.checkNext())
		{
			int n = t.checkNext();
			if (n == '*')
			{
				t.getNext();
				getTerm(c);
				c.pushcode(new MUL);
			}
			else if (n == '/')
			{
				t.getNext();
				getTerm(c);
				c.pushcode(new DIV);
			}
			else if (n == '%')
			{
				t.getNext();
				getTerm(c);
				c.pushcode(new MOD);
			}
			else break;
		}
	}
	void getTerm(Environment c)
	{
		int n = t.checkNext();
		if (n == '('/*')'*/)
		{
			t.getNext();
			ParseExpression(c, /*'('*/')');
		}
		else if (n == '-')
		{
			t.getNext();
			c.pushcode(new MINUS);
		}
		else if (n == Tokenizer.IDENTIFIER)
		{
			t.getNext();
			c.pushcode(new VARIABLE(t.nstr));
			getSuffOp(c);
		}
		else if (n == Tokenizer.INT)
		{
			t.getNext();
			c.pushcode(new PUSH_INT(t.nint));
			getSuffOp(c);
		}
		else if (n == Tokenizer.STRING)
		{
			t.getNext();
			c.pushcode(new PUSH_STRING(t.nstr));
			getSuffOp(c);
		}
		else
		{
			writefln("error");
			t.getNext();
		}
	}
	void getSuffOp(Environment c)
	{
		while (t.checkNext())
		{
			int n = t.checkNext();
			if (n == '('/*')'*/)
			{
				t.getNext();
				if (t.checkNext() != /*'('*/')')
				{
					ParseExpression(c, /*'('*/')');
				}
				else
				{
					t.getNext();	// no argument
					c.pushcode(new PUSH_NULL);
				}
				c.pushcode(new CALL);
			}
			else break;
		}
	}
}
