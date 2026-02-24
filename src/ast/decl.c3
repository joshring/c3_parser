module c3_parser::ast;

import std::io;
import handle;

alias DeclHandle = handle::Handle;

enum DeclType
{
	MODULE,
	IMPORT,
	FUNC,
}

struct Decl (Printable)
{
	DeclType type;
	AstRange name;
	AstRange[] attributes;

	union
	{
		FuncDecl func;
		// more types go here later
	}
}

fn usz? Decl.to_format(&self, Formatter* fmt) @dynamic
{
	switch (self.type)
	{
	case MODULE:
		return fmt.printf("{ <MODULE> name: %s, attributes: %s }",
			self.name,
			self.attributes,
		);
	case IMPORT: 
		return fmt.printf("{ <IMPORT> }");
	case FUNC:
		return fmt.printf("{ <FUNC> name: %s, attributes: %s, ret_type: %s, args: %s }",
			self.name,
			self.attributes,
			self.func.ret_type,
			self.func.args,
		);
	}
}

fn String? Decl.to_string(self, Allocator alloc, String text)
{
	switch (self.type)
	{
	case MODULE:
		return string::format(alloc, "(decl_module %s)", self.name.slice_text(text));
	case IMPORT:
		return string::format(alloc, "(decl_import)");
	case FUNC:
		return string::format(alloc, "(<FuncDecl> %s %s (%s))",
			self.name.slice_text(text),
			self.func.ret_type.slice_text(text),
			self.func.args.slice_text(text),
		);
	}
}

struct FuncDecl
{
	AstRange ret_type;
	// range of whole args definition of function (includes parentheses)
	// TODO: turn this into a slice of AST node variables
	AstRange args;
	StmtHandle block;
}

struct VarDecl 
{
	AstRange name;
}