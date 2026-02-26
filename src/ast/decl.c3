module c3_parser::ast;

import std::io;

enum DeclType
{
	MODULE,
	IMPORT,
	FUNC,
}

struct Decl (Printable)
{
	DeclType type;
	Ident name;
	AstRange[] attributes;

	union
	{
		FuncDecl func;
		ModuleDecl mod;
		ImportDecl imp;
		// more types go here later
	}
}

struct FuncDecl
{
	Ident ret_type;
	// range of whole args definition of function (includes parentheses)
	// TODO: turn this into a slice of AST node variables
	Ident args;
	Stmt* block;
}

struct VarDecl 
{
	Ident name;
}

struct ModuleDecl 
{
	Ident name;
}

struct ImportDecl 
{
	Ident name;
}
