import std.conv;
import environment;
import code;

class variable
{
	alias variable function(variable) cfunction;
	class Variable
	{
		class vBase
		{
			vBase clone(){return new vBase();}
			bool toBool(){return false;}
			int toInt(){return 0;}
			string toString(){return "";}
			variable child(string s){return new variable;}
			vBase substitution(Variable v){return v.x.clone();}
			void add(Variable v){}
			void sub(Variable v){}
			void mul(Variable v){}
			void div(Variable v){}
			void mod(Variable v){}
			bool eq(Variable v){return false;}
			bool ne(Variable v){return false;}
			bool le(Variable v){return false;}
			bool ge(Variable v){return false;}
			bool lt(Variable v){return false;}
			bool gt(Variable v){return false;}
			variable call(Environment e, variable arg){return arg;}
		}
		class vInt : vBase
		{
			this(int i){x = i;}
			vBase clone(){return new vInt(x);}
			bool toBool(){return x != 0;}
			int toInt(){return x;}
			string toString(){return to!(string)(x);}
			vBase substitution(Variable v){x = v.toInt();return this;}
			void add(Variable v){x += v.toInt();}
			void sub(Variable v){x -= v.toInt();}
			void mul(Variable v){x *= v.toInt();}
			void div(Variable v){x /= v.toInt();}
			void mod(Variable v){x %= v.toInt();}
			bool eq(Variable v){return x == v.toInt();}
			bool ne(Variable v){return x != v.toInt();}
			bool le(Variable v){return x <= v.toInt();}
			bool ge(Variable v){return x >= v.toInt();}
			bool lt(Variable v){return x < v.toInt();}
			bool gt(Variable v){return x > v.toInt();}
			int x;
		}
		class vString : vBase
		{
			this(string s){x = s;}
			vBase clone(){return new vString(x);}
			bool toBool(){return x.length != 0;}
			int toInt(){return to!(int)(x);}
			string toString(){return x;}
			vBase substitution(Variable v){x = v.toString();return this;}
			void add(variable v){x ~= v.toString();}
			string x;
		}
		class vObject : vBase
		{
			variable[string] member;
			Code code;
			variable child(string s){if (!(s in member))member[s] = new variable();return member[s];}
			vBase substitution(Variable v)
			{
				return v.x.clone();
			}
//			variable call(Environment e, variable arg)
//			{
//				return arg;
//			}
		}
		class vFunction : vBase
		{
			cfunction f;
			this(cfunction func){f = func;}
			vBase clone(){return new vFunction(f);}
			variable call(Environment e, variable arg)
			{
				return f(arg);
			}
		}
		vBase x = null;
		this()			{x = new vObject();}
		this(int i)		{x = new vInt(i);}
		this(string s)	{x = new vString(s);}
		this(cfunction f)	{x = new vFunction(f);}
		this(vBase v)	{x = v;}
		Variable clone(){return new Variable(x.clone());}
		bool toBool(){return x.toBool();}
		int toInt(){return x.toInt();}
		string toString(){return x.toString();}
		variable child(string s){return x.child(s);}
		void substitution(Variable v){x = x.substitution(v);}
		void add(Variable v){x.add(v);}
		void sub(Variable v){x.sub(v);}
		void mul(Variable v){x.mul(v);}
		void div(Variable v){x.div(v);}
		void mod(Variable v){x.mod(v);}
		bool eq(Variable v){return x.eq(v);}
		bool ne(Variable v){return x.ne(v);}
		bool le(Variable v){return x.le(v);}
		bool ge(Variable v){return x.ge(v);}
		bool lt(Variable v){return x.lt(v);}
		bool gt(Variable v){return x.gt(v);}
		variable call(Environment e, variable arg){return x.call(e, arg);}
	}
	Variable x = null;
	this()			{x = new Variable();}
	this(int i)		{x = new Variable(i);}
	this(string s)	{x = new Variable(s);}
	this(cfunction f)	{x = new Variable(f);}
	this(Variable v){x = v;}
	variable clone(){return new variable(x.clone());}
	int toInt(){return x.toInt();}
	string toString(){return x.toString();}
	variable opIndex(string s){return x.child(s);}
	variable substitution(variable v){x.substitution(v.x);return this;}
	variable add(variable v){x.add(v.x);return this;}
	variable sub(variable v){x.sub(v.x);return this;}
	variable mul(variable v){x.mul(v.x);return this;}
	variable div(variable v){x.div(v.x);return this;}
	variable mod(variable v){x.mod(v.x);return this;}
	bool eq(variable v){return x.eq(v.x);}
	bool ne(variable v){return x.ne(v.x);}
	bool le(variable v){return x.le(v.x);}
	bool ge(variable v){return x.ge(v.x);}
	bool lt(variable v){return x.lt(v.x);}
	bool gt(variable v){return x.gt(v.x);}
	variable call(Environment e, variable arg)
	{
		return x.call(e, arg);
	}
}
