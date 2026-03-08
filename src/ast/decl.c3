module c3_parser::ast;

import std::io;

import c3_parser::common;

enum DeclType
{
	MODULE,
	IMPORT,
	FUNC,
	ALIAS,
	TYPEDEF,
	VAR,
}

struct Decl (Printable)
{
	DeclType type;
	SourceSpan span;
	Ident name;
	SourceSpan[] attributes;

	union
	{
		FuncDecl func;
		ModuleDecl mod;
		ImportDecl imp;
		VarDecl var_decl;
		// more types go here later
	}
}

struct FuncDecl
{
	Ident ret_type;
	// range of whole args definition of function (includes parentheses)
	// TODO: turn this into a slice of AST node variables
	SourceSpan args;
	Stmt* block;
}

<*
	all kind of variables
	see 'VarDeclKind'
*>
struct VarDecl
{
	VarDeclKind kind;
	bool no_init;
	bool is_threadlocal;

	union 
	{
		Expr* init_expr;
		Decl* alis;
	}
}

struct EnumDecl 
{
	Decl[] values;
	Decl[] parameters;
}

struct ModuleDecl 
{
	SourceSpan name;
}

struct ImportDecl 
{
	Ident name;
}

struct AliasDecl 
{
	Ident name;
	Decl* decl;
	bool is_func;
	bool is_redef;
}

struct TypedefDecl
{
	Ident name;
	Decl* decl;
}