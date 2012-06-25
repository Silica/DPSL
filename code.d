import environment;

enum RC
{
	NONE = 0,
	CALL,
	FOR,
}

class Code
{
	OpCode code[];
	this()
	{
		code = new OpCode[0];
	}
	bool Run(Environment e, ref int line)
	{
		while (line < code.length)
		{
			auto r = code[line++].Exec(e);
			if (!r)
				continue;
			return true;
		}
		e.endScope();
		return true;
	}
	void pushcode(OpCode o)
	{
		code[code.length++] = o;
	}
	void pushcodes(Code c)
	{
		code ~= c.code;
	}
	int getLength()
	{
		return code.length;
	}
}

class OpCode
{
	RC Exec(Environment e){return RC.NONE;}
	void set(int i){}
}
class PUSH_INT : OpCode
{
	this(int i){x = i;}
	RC Exec(Environment e)
	{
		e.push(new variable(x));
		return RC.NONE;
	}
	int x;
}
class PUSH_STRING : OpCode
{
	this(string s){x = s;}
	RC Exec(Environment e)
	{
		e.push(new variable(x));
		return RC.NONE;
	}
	string x;
}
class PUSH_NULL : OpCode
{
	RC Exec(Environment e)
	{
		e.push(new variable());
		return RC.NONE;
	}
}
class VARIABLE : OpCode
{
	this(string s){x = s;}
	RC Exec(Environment e)
	{
		e.push(e.getVariable(x));
		return RC.NONE;
	}
	string x;
}
class POP : OpCode
{
	RC Exec(Environment e)
	{
		e.pop();
		return RC.NONE;
	}
}
class SUBSTITUTION : OpCode
{
	RC Exec(Environment e)
	{
		variable r = e.pop();
		variable l = e.pop();
		l.substitution(r);
		e.push(l);
		return RC.NONE;
	}
}
class SADD : OpCode
{
	RC Exec(Environment e)
	{
		variable r = e.pop();
		variable l = e.pop();
		l.add(r);
		e.push(l);
		return RC.NONE;
	}
}
class ADD : OpCode
{
	RC Exec(Environment e)
	{
		variable r = e.pop();
		variable l = e.pop();
		variable a = l.clone();
		a.add(r);
		e.push(a);
		return RC.NONE;
	}
}
class SSUB : OpCode
{
	RC Exec(Environment e)
	{
		variable r = e.pop();
		variable l = e.pop();
		l.sub(r);
		e.push(l);
		return RC.NONE;
	}
}
class SUB : OpCode
{
	RC Exec(Environment e)
	{
		variable r = e.pop();
		variable l = e.pop();
		variable a = l.clone();
		a.sub(r);
		e.push(a);
		return RC.NONE;
	}
}
class SMUL : OpCode
{
	RC Exec(Environment e)
	{
		variable r = e.pop();
		variable l = e.pop();
		l.mul(r);
		e.push(l);
		return RC.NONE;
	}
}
class MUL : OpCode
{
	RC Exec(Environment e)
	{
		variable r = e.pop();
		variable l = e.pop();
		variable a = l.clone();
		a.mul(r);
		e.push(a);
		return RC.NONE;
	}
}
class SDIV : OpCode
{
	RC Exec(Environment e)
	{
		variable r = e.pop();
		variable l = e.pop();
		l.div(r);
		e.push(l);
		return RC.NONE;
	}
}
class DIV : OpCode
{
	RC Exec(Environment e)
	{
		variable r = e.pop();
		variable l = e.pop();
		variable a = l.clone();
		a.div(r);
		e.push(a);
		return RC.NONE;
	}
}
class SMOD : OpCode
{
	RC Exec(Environment e)
	{
		variable r = e.pop();
		variable l = e.pop();
		l.mod(r);
		e.push(l);
		return RC.NONE;
	}
}
class MOD : OpCode
{
	RC Exec(Environment e)
	{
		variable r = e.pop();
		variable l = e.pop();
		variable a = l.clone();
		a.mod(r);
		e.push(a);
		return RC.NONE;
	}
}
class EQ : OpCode
{
	RC Exec(Environment e)
	{
		variable r = e.pop();
		variable l = e.pop();
		e.push(new variable(l.eq(r)));
		return RC.NONE;
	}
}
class NE : OpCode
{
	RC Exec(Environment e)
	{
		variable r = e.pop();
		variable l = e.pop();
		e.push(new variable(l.ne(r)));
		return RC.NONE;
	}
}
class LE : OpCode
{
	RC Exec(Environment e)
	{
		variable r = e.pop();
		variable l = e.pop();
		e.push(new variable(l.le(r)));
		return RC.NONE;
	}
}
class GE : OpCode
{
	RC Exec(Environment e)
	{
		variable r = e.pop();
		variable l = e.pop();
		e.push(new variable(l.ge(r)));
		return RC.NONE;
	}
}
class LT : OpCode
{
	RC Exec(Environment e)
	{
		variable r = e.pop();
		variable l = e.pop();
		e.push(new variable(l.lt(r)));
		return RC.NONE;
	}
}
class GT : OpCode
{
	RC Exec(Environment e)
	{
		variable r = e.pop();
		variable l = e.pop();
		e.push(new variable(l.gt(r)));
		return RC.NONE;
	}
}
class MINUS : OpCode
{
	RC Exec(Environment e)
	{
		variable v = e.pop();
		e.push(new variable(-v.toInt()));
		return RC.NONE;
	}
}
class JMP : OpCode
{
	int j;
	this(int i){j = i;}
	void set(int i){j = i;}
	RC Exec(Environment e)
	{
		e.Jump(j);
		return RC.NONE;
	}
}
class JF : OpCode
{
	int j;
	this(int i){j = i;}
	void set(int i){j = i;}
	RC Exec(Environment e)
	{
		variable v = e.pop();
		if (!v.toBool())
			e.Jump(j);
		return RC.NONE;
	}
}
class JR : OpCode
{
	int j;
	this(int i){j = i;}
	void set(int i){j = i;}
	RC Exec(Environment e)
	{
		e.RJump(j);
		return RC.NONE;
	}
}
class JRF : OpCode
{
	int j;
	this(int i){j = i;}
	void set(int i){j = i;}
	RC Exec(Environment e)
	{
		variable v = e.pop();
		if (!v.toBool())
			e.RJump(j);
		return RC.NONE;
	}
}
class LOOP : OpCode
{
	int cline;
	Code code;
	this(Code c, int i){code = c;cline = i;}
	RC Exec(Environment e)
	{
		e.addScope(new Scope(code));
		return RC.FOR;
	}
}
class CALL : OpCode
{
	RC Exec(Environment e)
	{
		variable a = e.pop();
		variable f = e.pop();
		variable r = f.call(e, a);
		e.push(a);
		return RC.NONE;
	}
}
