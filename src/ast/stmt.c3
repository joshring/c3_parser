module c3_parser::ast;

import std::io;

enum StmtType
{
	BLOCK, // the body of a function
	RETURN,
	DECL,
	VAR,
	DEFER,
}

struct Stmt
{
	StmtType type;

	union
	{
		BlockStmt block;
		ReturnStmt return_stmt;
		DeclStmt decl_stmt;
		DeferStmt defer_stmt;
	}
}

<*
	The body of a function and so on.

	body.start -> '{' 
	body.end -> '}'
*>
struct BlockStmt
{
	AstRange body;
	Stmt[] stmts;
}

<*
	// a Decleration which is inside a Block
		BlockStmt
		{ 
			int my_var = 1; <- DeclStmt
		}
*>
struct DeclStmt
{	
	// only going to be a VarDecl
	Decl* decl;
}

struct ExprStmt 
{
	Expr* expr;
}

struct ReturnStmt
{
	AstRange ret;
}

struct DeferStmt 
{
	AstRange def;
	Stmt* block;
	bool is_try;
	bool is_catch;
}

struct ForEachStmt 
{
	Stmt* block;
	bool iterator;
	bool is_reverse;
	bool index_by_ref;
	bool value_by_ref;
}
