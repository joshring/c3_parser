module c3_parser::ast;

import std::io;
import handle;

alias DeclHandle = handle::Handle;

enum DeclType
{
	MODULE,
	IMPORT,
	FUNC,
}

struct Decl
{
	DeclType type;
	AstRange name;
	AstRange[] attributes;

	union
	{
		DeclFunc func;
		// more types go here later
	}
}

struct DeclFunc
{
	AstRange ret_type;
	// range of whole args definition of function (includes parentheses)
	// TODO: turn this into a slice of AST node variables
	AstRange args;
	StmtHandle body;
}
