import variable;
import code;

class Environment
{
	variable[16] stack;
	int ns = 0;
	variable global;
//	Scope sc;

	this(){global = new variable;
		code = new Code;
	}
	variable getVariable(string s){return global[s];}
	void push(variable v){stack[ns++] = v;}
	variable pop(){return stack[--ns];}
	variable Run()
	{
//		sc.Run(this);
		code.Run(this, line);
		return pop();
	}

	int line = 0;
	Code code;
	void pushcode(OpCode o)
	{
		code.push(o);
	}

}

class Scope
{
	Code code;
	int line = 0;
	void Run(Environment e)
	{
		code.Run(e, line);
	}
}
