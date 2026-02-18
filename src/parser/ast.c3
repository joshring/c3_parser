module c3_parser::parser;
import c3_parser::ast;

import c3::lexer;

faultdef
	INCOMPATIBLE,
;

fn Lexer? AstNode.parse(&self, Lexer lexer)
{
	self.range.start = { lexer.ln, lexer.col };
	Lexer new_lexer;
	switch (true)
	{
	case @ok(@try(new_lexer, self.decl.parse(lexer))):
		self.type = DECLARATION;
		self.range.end = new_lexer.position();
		return new_lexer;
	case @ok(@try(new_lexer, self.expr.parse(lexer))):
		self.type = EXPRESSION;
		self.range.end = new_lexer.position();
		return new_lexer;
	default: return INCOMPATIBLE?;
	}
}
