module c3_parser::ast;
import c3::lexer;

import c3_parser::common;
import c3_parser::diagnostics;

import std::io;
import std::collections::range;
import std::collections::list;

struct Ident 
{
	SourceSpan range;
	uint id;
}

fn String Ident.text(self)
{
	FileEntry* entry = diagnostics::files[(usz)self.range.file_id];
	return entry.source[self.range.start..self.range.end];
}

struct Ast 
{
	List{ Decl* } decls;
}