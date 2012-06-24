import std.conv;
import environment;
import code;

class variable
{
	alias variable function(variable) cfunction;
	class vBase
	{
		vBase clone(){return new vBase();}
		bool toBool(){return false;}
		int toInt(){return 0;}
		string toString(){return "";}
		variable child(string s){return new variable;}
		vBase substitution(variable v){return v.x.clone();}
		void add(variable v){}
		void sub(variable v){}
		void mul(variable v){}
		void div(variable v){}
		void mod(variable v){}
		bool eq(variable v){return false;}
		bool ne(variable v){return false;}
		bool le(variable v){return false;}
		bool ge(variable v){return false;}
		bool lt(variable v){return false;}
		bool gt(variable v){return false;}
		void setcode(Code c){}
		variable call(Environment e, variable arg){return arg;}
	}
	class vInt : vBase
	{
		this(int i){x = i;}
		vBase clone(){return new vInt(x);}
		bool toBool(){return x != 0;}
		int toInt(){return x;}
		string toString(){return to!(string)(x);}
		vBase substitution(variable v){x = v.toInt();return this;}
		void add(variable v){x += v.toInt();}
		void sub(variable v){x -= v.toInt();}
		void mul(variable v){x *= v.toInt();}
		void div(variable v){x /= v.toInt();}
		void mod(variable v){x %= v.toInt();}
		bool eq(variable v){return x == v.toInt();}
		bool ne(variable v){return x != v.toInt();}
		bool le(variable v){return x <= v.toInt();}
		bool ge(variable v){return x >= v.toInt();}
		bool lt(variable v){return x < v.toInt();}
		bool gt(variable v){return x > v.toInt();}
		int x;
	}
	class vString : vBase
	{
		this(string s){x = s;}
		vBase clone(){return new vString(x);}
		bool toBool(){return x.length != 0;}
		int toInt(){return to!(int)(x);}
		string toString(){return x;}
		vBase substitution(variable v){x = v.toString();return this;}
		void add(variable v){x ~= v.toString();}
		string x;
	}
	class vObject : vBase
	{
		variable[string] member;
		Code code;
		variable child(string s){if (!(s in member))member[s] = new variable();return member[s];}
		vBase substitution(variable v)
		{
			return v.x.clone();
		}
		void setcode(Code c){code = c;}
//		variable call(Environment e, variable arg)
//		{
//			return arg;
//		}
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
	this(vBase v){x = v;}
	variable clone(){return new variable(x.clone());}
	int toInt(){return x.toInt();}
	string toString(){return x.toString();}
	variable opIndex(string s){return x.child(s);}
	variable substitution(variable v){x = x.substitution(v);return this;}
	variable add(variable v){x.add(v);return this;}
	variable sub(variable v){x.sub(v);return this;}
	variable mul(variable v){x.mul(v);return this;}
	variable div(variable v){x.div(v);return this;}
	variable mod(variable v){x.mod(v);return this;}
	bool eq(variable v){return x.eq(v);}
	bool ne(variable v){return x.ne(v);}
	bool le(variable v){return x.le(v);}
	bool ge(variable v){return x.ge(v);}
	bool lt(variable v){return x.lt(v);}
	bool gt(variable v){return x.gt(v);}
	void setcode(Code c){x.setcode(c);}
	variable call(Environment e, variable arg)
	{
		return x.call(e, arg);
	}
}
