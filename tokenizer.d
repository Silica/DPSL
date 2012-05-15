class Tokenizer
{
	string s;
	int i = 0;
	this(string x)
	{
		s = x;
	}
	public string nstr;
	public int nint;
	int next = UNSET;

	enum
	{
		UNSET = -1,
		NONE = 0,
		IDENTIFIER = 1,
		INT,HEX,NUMBER,STRING,
		ASSIGN,
		INC,DEC,
		EQ,NE,LE,GE,

		SADD,SSUB,SMUL,SDIV,SMOD,
		SAND,SOR,SXOR,

		SHL,SHR,SSHL,SSHR,

		BAND,BOR,
	}
	void whitespace()
	{
		for (; i < s.length; i++)
		{
			if (s[i] == ' ' || s[i] == '\t' || s[i] == '\r' || s[i] == '\n')
				continue;
			break;
		}
	}
	void string_literal()
	{
		int h = i;
		nstr = "";
		for (; i < s.length; i++)
		{
			if (s[i] == '"')
			{
				nstr = s[h..i];
				i++;
				return;
			}
		}
	}
	int getNext()
	{
		if (next > 0)
		{
			int n = next;
			next = UNSET;
			return n;
		}
		if (next < 0)
			return doNext();
		return 0;
	}
	int checkNext()
	{
		if (next > 0)
			return next;
		if (next < 0)
			return next = doNext();
		return 0;
	}
	bool getNextIf(int t)
	{
		if (checkNext() == t)
		{
			next = UNSET;
			return true;
		}
		return false;
	}
	int doNext()
	{
		whitespace();
		if (i == s.length)
			return 0;
		switch (s[i++])
		{
		case '=':	if (s[i] == '='){++i;return EQ;}
										return '=';
		case '+':	if (s[i] == '+'){++i;return INC;}
					if (s[i] == '='){++i;return SADD;}
										return '+';
		case '-':	if (s[i] == '-'){++i;return DEC;}
					if (s[i] == '='){++i;return SSUB;}
										return '-';
		case '*':	if (s[i] == '='){++i;return SMUL;}
										return '*';
		case '/':	if (s[i] == '='){++i;return SDIV;}
										return '/';
		case '%':	if (s[i] == '='){++i;return SMOD;}
										return '%';
		case '&':	if (s[i] == '='){++i;return SAND;}
					if (s[i] == '&'){++i;return BAND;}
										return '&';
		case '|':	if (s[i] == '='){++i;return SOR;}
					if (s[i] == '|'){++i;return BOR;}
										return '|';
		case '^':	if (s[i] == '='){++i;return SXOR;}
										return '^';
		case '<':	if (s[i] == '='){++i;return LE;}
					if (s[i] == '<'){++i;
					if (s[i] == '='){++i;return SSHL;}
										return SHL;}
										return '<';
		case '>':	if (s[i] == '='){++i;return GE;}
					if (s[i] == '>'){++i;
					if (s[i] == '='){++i;return SSHR;}
										return SHR;}
										return '>';
		case '!':	if (s[i] == '='){++i;return NE;}
										return '!';
		case '~':						return '~';
		case '.':						return '.';
		case ',':						return ',';
		case ';':						return ';';
		case '[':						return '[';
		case ']':						return ']';
		case '(':						return '(';
		case ')':						return ')';
		case '{':						return '{';
		case '}':						return '}';
		case '?':						return '?';
		case ':':	if (s[i] == '='){++i;return ASSIGN;}
										return ':';
		case '"':string_literal();		return STRING;
		case '$':						return '$';
		case '@':						return '@';
		default:
			i--;
		}

		if (s[i] == '_' || (s[i] >= 'A' && s[i] <= 'Z') || (s[i] >= 'a' && s[i] <= 'z'))
		{
			int h = i;
			for (i++; i < s.length; i++)
			{
				if (s[i] == '_' || (s[i] >= 'A' && s[i] <= 'Z') || (s[i] >= 'a' && s[i] <= 'z') || (s[i] >= '0' && s[i] <= '9'))
					continue;
				break;
			}
			nstr = s[h..i];
			return IDENTIFIER;
		}

		if (s[i] >= '0' && s[i] <= '9')
		{
			nint = s[i] - '0';
			for (i++; i < s.length; i++)
			{
				if (s[i] >= '0' && s[i] <= '9')
				{
					nint *= 10;
					nint += s[i] - '0';
					continue;
				}
				break;
			}
			return INT;
		}
		i++;
		return -1;
	}
}
