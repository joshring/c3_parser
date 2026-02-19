module c3_parser::parser;
import c3_parser::ast;

import c3::lexer;

faultdef
	INCOMPATIBLE,
;

fn AstNode? Lexer.parse_ast(&self)
{
	Lexer old_lexer = *self;
	defer catch *self = old_lexer;

	AstNode ast;
	ast.range.start = { self.ln, self.col };
	defer ast.range.end = self.position();

	if (try decl = self.parse_decl())
	{
		ast.type = DECLARATION;
		ast.decl = decl;
	}
	else if (try expr = self.parse_expr())
	{
		ast.type = EXPRESSION;
		ast.expr = expr;
	}
	else
	{
		log::debug("Failed to parse AST node");
		return INCOMPATIBLE?;
	}
	return ast;
}
