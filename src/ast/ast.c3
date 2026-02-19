module c3_parser::ast;
import c3::lexer;

import std::io;
import std::collections::range;

struct AstPosition (Printable)
{
	usz line, col;
}
fn bool AstPosition.eq(self, AstPosition other) @operator(==) @inline
	=> self.line == other.line && self.col == other.col;
fn bool AstPosition.lt(self, AstPosition other) @inline
	=> self.line < other.line
		|| (self.line == other.line && self.col < other.col);
fn bool AstPosition.le(self, AstPosition other) @inline
	=> self.line < other.line
		|| (self.line == other.line && self.col <= other.col);
fn bool AstPosition.gt(self, AstPosition other) @inline
	=> !self.le(other);
fn bool AstPosition.ge(self, AstPosition other) @inline
	=> !self.lt(other);
fn usz? AstPosition.to_format(&self, Formatter* fmt) @dynamic
	=> fmt.printf("%d:%d", self.line, self.col);
// col is the position one char after the last parsed token (often not wanted)
macro AstPosition Lexer.position(self)
	=> { self.ln, self.col - 1 };
macro AstPosition Token.position(self)
	=> { self.ln, self.col - self.len }; // col is the end of the token
macro AstPosition Token.position_end(self)
	=> { self.ln, self.col - 1 };

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

faultdef
	RANGE_OOB,
	RANGE_INVALID,
;