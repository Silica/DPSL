
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
	void Parse(Code v)
	{
		v.pushcode(new VARIABLE("arg"));
		while (t.checkNext())
			ParseStatement(v);
	}
	void ParseStatement(Code v)
	{
		int n = t.checkNext();
		if (n == ';')
		{
			t.getNext();
			return;
		}
		if (n == '{'/*'}'*/)
		{
			t.getNext();
			while (t.checkNext())
			{
				if (t.checkNext() == /*'{'*/'}')
				{
					t.getNext();
					break;
				}
				ParseStatement(v);
			}
			return;
		}
		if (n == Tokenizer.IDENTIFIER)
		{
			if (t.nstr == "if")
			{
				t.getNext();
				ParseIf(v);
				return;
			}
			if (t.nstr == "for")
			{
				t.getNext();
				ParseFor(v);
				return;
			}
		}
		v.pushcode(new POP);
		ParseExpression(v, ';');
	}
	void ParseIf(Code c)
	{
		auto v = new Code();
		if (t.getNext() != '('/*')'*/)
			writefln("error if");
		ParseExpression(v, /*'('*/')');
		int l = v.getLength();
		OpCode oc = null;
		if (l)
		{
			oc = new JRF(0);
			v.pushcode(oc);
			l = v.getLength();
		}
		else
			writefln("error ;");
		ParseStatement(v);
		if (t.checkNext() == Tokenizer.IDENTIFIER && t.nstr == "else")
		{
			t.getNext();
			if (oc)
				oc.set(v.getLength()+1-l);
			oc = new JR(0);
			v.pushcode(oc);
			l = v.getLength();
			ParseStatement(v);
			oc.set(v.getLength()-l);
		}
		else if (oc)
			oc.set(v.getLength()-l);
		c.pushcodes(v);
	}
	void ParseFor(Code c)
	{
		auto v = new Code();
		int l = 0;
		if (t.getNext() != '('/*')'*/)
			writefln("error for");
		if (t.checkNext() != ';')
		{
			v.pushcode(new POP);
			ParseExpression(v, ';');
			l = v.getLength();
		}
		else
			t.getNext();
		OpCode oc = null;
		if (t.checkNext() != ';')
		{
			ParseExpression(v, ';');
			if (v.getLength() - l)
			{
				oc = new JF(v.getLength());
				v.pushcode(oc);
			}
		}
		else
			t.getNext();
		scope x = new Code();
		if (t.checkNext() != /*'('*/')')
			ParseExpression(x, /*'('*/')');
		else
			t.getNext();
		ParseStatement(v);
		int cline = v.getLength();
		if (x.getLength())
		{
			v.pushcode(new POP);
			v.pushcodes(x);
		}
		v.pushcode(new JMP(l));
		if (oc)
			oc.set(v.getLength());
		c.pushcode(new LOOP(v, cline));
	}
	void ParseExpression(Code c, char e, bool l = false)
	{
		getexp13(c, l);
		if (!t.getNextIf(e))
			writefln("error ;");
	}
	void getexp13(Code c, bool l = false)
	{
		getexp12(c, l);
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
	void getexp12(Code c, bool l = false)
	{
		getexp8(c, l);
	}
	void getexp8(Code c, bool l = false)
	{
		getexp7(c, l);
		while (t.checkNext())
		{
			int n = t.checkNext();
			if (n == Tokenizer.EQ)
			{
				t.getNext();
				getexp7(c, l);
				c.pushcode(new EQ);
			}
			else if (n == Tokenizer.NE)
			{
				t.getNext();
				getexp7(c, l);
				c.pushcode(new NE);
			}
			else break;
		}
	}
	void getexp7(Code c, bool l = false)
	{
		getexp6(c, l);
		while (t.checkNext())
		{
			int n = t.checkNext();
			if (n == '<')
			{
				t.getNext();
				getexp6(c, l);
				c.pushcode(new LT);
			}
			else if (n == '>')
			{
				t.getNext();
				getexp6(c, l);
				c.pushcode(new GT);
			}
			else if (n == Tokenizer.LE)
			{
				t.getNext();
				getexp6(c, l);
				c.pushcode(new LE);
			}
			else if (n == Tokenizer.GE)
			{
				t.getNext();
				getexp6(c, l);
				c.pushcode(new GE);
			}
			else break;
		}
	}
	void getexp6(Code c, bool l = false)
	{
		getexp2(c, l);
	}
	void getexp2(Code c, bool l = false)
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
	void getexp1(Code c, bool l = false)
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
	void getTerm(Code c)
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
	void getSuffOp(Code c)
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
