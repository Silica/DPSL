import variable;
import code;

class Environment
{
	variable[16] stack;
	int ns = 0;
	variable global;
	Scope sc = null;

	this(){global = new variable;}
	variable getVariable(string s){return global[s];}
	void push(variable v){stack[ns++] = v;}
	variable pop(){return stack[--ns];}
	variable Run()
	{
		while (sc && sc.Run(this)){}
		return pop();
	}
	void addScope(Scope s)
	{
		if (sc)
			s.next = sc;
		sc = s;
	}
	void endScope()
	{
		sc = sc.next;
	}
	void Jump(int i){sc.line = i;}
	void RJump(int i){sc.line += i;}

	void setcode(Code c)
	{
		global.setcode(c);
		addScope(new Scope(c));
	}

}

class Scope
{
	Code code;
	Scope next = null;
	int line = 0;
	this(Code c){code = c;}
	bool Run(Environment e)
	{
		return code.Run(e, line);
	}
}
