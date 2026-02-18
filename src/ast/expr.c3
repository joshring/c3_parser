module c3_parser::ast;

import std::io;

enum AstNodeExprType
{
	IDENT,
	TYPE_IDENT,
}
struct AstNodeExpr (Printable)
{
	AstNodeExprType type;
	union
	{
		AstNodeExprIdent ident;
		AstNodeExprTypeIdent type_ident;
	}
}

fn usz? AstNodeExpr.to_format(&self, Formatter* fmt) @dynamic
{
	switch (self.type)
	{
	case IDENT:
		return fmt.printf("{ <IDENT> type: %s }", self.ident.name);
	case TYPE_IDENT:
		return fmt.printf("{ <TYPE_IDENT> type: %s }", self.type_ident.type);
	}
}
fn String? AstNodeExpr.to_string(self, Allocator alloc, String text)
{
	switch (self.type)
	{
	case IDENT:
		return string::format(alloc, "(expr_ident %s)", self.ident.name.slice_text(text));
	case TYPE_IDENT:
		return string::format(alloc, "(expr_type_ident %s)", self.type_ident.type.slice_text(text));
	}
}

struct AstNodeExprIdent
{
	AstRange name;
}
struct AstNodeExprTypeIdent
{
	// range for entire type ("MyType"), even for generics ("HashSet{int}")
	AstRange type;
}
