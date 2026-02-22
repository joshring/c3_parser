module c3_parser::ast;

import std::io;
import handle;

alias StmtHandle = handle::Handle;

enum StmtType (Printable)
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

fn usz? Stmt.to_format(&self, Formatter* fmt) @dynamic
{
	switch (self.type)
	{
	case BODY:
		return fmt.printf("{ <BODY> : %s }",
			self.body.body,
		);
	case RETURN: 
		return fmt.printf("{ <RETURN> }");
	}
}

fn String? Stmt.to_string(self, Allocator alloc, String text)
{
	switch (self.type)
	{
	case BODY:
		return string::format(alloc, "(StmtBody %s)", self.body.body.slice_text(text));
	case RETURN:
		return string::format(alloc, "(decl_import)");
	}
}

<*
	The body of a function and so on.

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