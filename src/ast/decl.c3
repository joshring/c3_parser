module c3_parser::ast;

import std::io;

enum AstNodeDeclType
{
	MODULE,
	FUNC,
}
struct AstNodeDecl (Printable)
{
	AstNodeDeclType type;
	AstRange name;
	AstRange[] attributes;
	union
	{
		AstNodeDeclFunc func;
		// more types go here later
	}
}

fn usz? AstNodeDecl.to_format(&self, Formatter* fmt) @dynamic
{
	switch (self.type)
	{
	case MODULE:
		return fmt.printf("{ <MODULE> name: %s, attributes: %s }",
			self.name,
			self.attributes,
		);
	case FUNC:
		return fmt.printf("{ <MODULE> name: %s, attributes: %s, ret_type: %s, args: %s }",
			self.name,
			self.attributes,
			self.func.ret_type,
			self.func.args,
		);
	}
}
fn String? AstNodeDecl.to_string(self, Allocator alloc, String text)
{
	switch (self.type)
	{
	case MODULE:
		return string::format(alloc, "(decl_module %s)", self.name.slice_text(text));
	case FUNC:
		return string::format(alloc, "(decl_func %s %s %s)",
			self.name.slice_text(text),
			self.func.ret_type.slice_text(text),
			self.func.args.slice_text(text),
		);
	}
}

struct AstNodeDeclFunc
{
	AstRange ret_type;
	// range of whole args definition of function (includes parentheses)
	// TODO: turn this into a slice of AST node variables
	AstRange args;
}
