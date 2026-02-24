module c3_parser::ast;
import c3::lexer;

import std::io;
import std::collections::range;
import std::collections::list;

faultdef
	RANGE_OOB,
	RANGE_INVALID
;

struct AstPosition (Printable)
{
	usz line, col;
}

fn bool AstPosition.eq(self, AstPosition other) @operator(==) @inline => self.line == other.line && self.col == other.col;
fn bool AstPosition.lt(self, AstPosition other) @inline => self.line < other.line
		|| (self.line == other.line && self.col < other.col);
fn bool AstPosition.le(self, AstPosition other) @inline
	=> self.line < other.line
		|| (self.line == other.line && self.col <= other.col);

fn bool AstPosition.gt(self, AstPosition other) @inline => !self.le(other);
fn bool AstPosition.ge(self, AstPosition other) @inline => !self.lt(other);
fn usz? AstPosition.to_format(&self, Formatter* fmt) @dynamic => fmt.printf("%d:%d", self.line, self.col);

// col is the position one char after the last parsed token (often not wanted)
macro AstPosition Lexer.position(self)
	=> { self.ln, self.col - 1 };
macro AstPosition Token.position(self)
	=> { self.ln, self.col - self.len }; // col is the end of the token
macro AstPosition Token.position_end(self)
	=> { self.ln, self.col - 1 };

fn Range{usz}? AstRange.char_range(self, String text) => @pool()
{
	if (self.start.ge(self.end)) return RANGE_INVALID~;
	usz[] newline_indices = array::@indices_of(tmem, text, fn (e,i) => e == '\n');
	if (self.start.line > newline_indices.len || self.end.line > newline_indices.len)
	{
		return RANGE_OOB~;
	}
	usz start_pos =
		(self.start.line > 1 && newline_indices.len > 0
			? newline_indices[self.start.line - 2] + 1
			: 0)
		+ self.start.col - 1;
	usz end_pos =
		(self.end.line > 1 && newline_indices.len > 0
			? newline_indices[self.end.line - 2] + 1
			: 0)
		+ self.end.col - 1;
	if (start_pos >= text.len || end_pos >= text.len)
	{
		return RANGE_OOB~;
	}
	if (start_pos > end_pos) return RANGE_INVALID~;
	return { start_pos, end_pos };
}

fn usz? AstRange.len(self, String text) => self.char_range(text)!.len();

fn String? AstRange.slice_text(self, String text)
{
	Range{usz} char_range = self.char_range(text)!;
	return text[char_range.start..char_range.end];
}

struct AstRange
{
	AstPosition start, end;
}

typedef FileID = ushort;

struct SourceSpan 
{
	FileID file_id;
	usz offset;
	AstRange range;
}

enum NodeKind 
{
	DECLERATION,
	STATEMENT,
	EXPRESSION,
}

struct Ast 
{
	List{ Decl* } decls;
}