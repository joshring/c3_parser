module c3_parser::ast;

import std::io;
import handle;

alias StmtHandle = handle::Handle;

enum StmtType
{
	BODY, // the body of a function
	RETURN,
}

struct Stmt
{
	StmtType type;

	union
	{
		StmtBody body;
		StmtReturn return_stmt;
	}
}

<*
	body.start -> '{' 
	body.end -> '}'
*>
struct StmtBody
{
	AstRange body;
}

struct StmtReturn
{
	AstRange ret;
}