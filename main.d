
import std.stdio;

import variable;
import tokenizer;
import parser;

import code;
import environment;

variable Print(variable v)
{
	writefln("%s", v.toString());
	return v;
}

void main(string[] args)
{
	if (args.length == 1)
		return;
	auto f = File(args[1], "r");
	string s;
	while (!f.eof())
		s ~= f.readln();
	scope t = new Tokenizer(s);
	scope p = new Parser(t);

	scope e = new Environment;
	scope c = new Code;
	e.getVariable("print").substitution(new variable(&Print));
	p.Parse(c);
	e.setcode(c);
	e.Run();
}
