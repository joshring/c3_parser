module c3_parser::ast;

import std::io;
import handle;

alias ExprHandle = handle::Handle;

enum ExprType
{
	IDENT,
	TYPE_IDENT,
}

struct Expr
{
	ExprType type;
	union
	{
		ExprIdent ident;
		ExprTypeIdent type_ident;
	}
}

struct ExprIdent
{
	AstRange name;
}

struct ExprTypeIdent
{
	// range for entire type ("MyType"), even for generics ("HashSet{int}")
	AstRange type;
}
