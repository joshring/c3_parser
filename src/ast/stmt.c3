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

fn usz? Stmt.to_format(&self, Formatter* fmt) @dynamic
{
	switch (self.type)
	{
	case BLOCK:
		return fmt.printf("{ <BLOCK> : %s }",
			self.block.body,
		);
	case RETURN: 
		return fmt.printf("{ <RETURN> }");
	}
}

fn String? Stmt.to_string(self, Allocator alloc, String text)
{
	switch (self.type)
	{
	case BLOCK:
		return string::format(alloc, "(BlockStmt %s)", self.block.body.slice_text(text));
	case RETURN:
		return string::format(alloc, "(ReturnStmt)");
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