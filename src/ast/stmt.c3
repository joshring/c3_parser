module c3_parser::ast;

import std::io;

enum StmtType (Printable)
{
	BLOCK, // the body of a function
	RETURN,
}

struct Stmt
{
	StmtType type;

	union
	{
		BlockStmt block;
		ReturnStmt return_stmt;
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
}

struct ReturnStmt
{
	AstRange ret;
}