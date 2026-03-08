module c3_parser::ast;

import std::io;

import c3_parser::common;

enum ExprType
{
	TYPE_IDENT,
}

struct Expr
{
	ExprType type;
	union
	{
		ExprTypeIdent type_ident;
	}
}

struct ExprTypeIdent
{
	// range for entire type ("MyType"), even for generics ("HashSet{int}")
	SourceSpan type;
}
