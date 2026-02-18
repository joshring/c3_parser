module c3_parser::ast;

import std::io;

enum AstNodeExprType
{
	TYPE_IDENT,
}
struct AstNodeExpr (Printable)
{
	AstNodeExprType type;
	union
	{
		AstNodeExprTypeIdent type_ident;
	}
}

fn usz? AstNodeExpr.to_format(&self, Formatter* fmt) @dynamic
{
	switch (self.type)
	{
	case TYPE_IDENT:
		return fmt.printf("{ <TYPE_IDENT> type: %s }", self.type_ident.type);
	}
}
fn String? AstNodeExpr.to_string(self, Allocator alloc, String text)
{
	switch (self.type)
	{
	case TYPE_IDENT:
		return string::format(alloc, "(expr_type_ident %s)", self.type_ident.type.slice_text(text));
	}
}

struct AstNodeExprTypeIdent
{
	// range for entire type ("MyType"), even for generics ("HashSet{int}")
	AstRange type;
}
