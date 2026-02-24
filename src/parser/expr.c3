module c3_parser::parser;
import c3_parser::ast;
import c3::lexer;

fn Expr*? parse_ident(Parser* parser)
{
	if (catch expect(parser, TokenType.IDENT))
	{
		log::error("expected ident");
		return UNEXPECTED_TOKEN~;
	}

	Expr* expr = mem::tnew(Expr);

	expr.type = ExprType.IDENT;

	expr.ident.name.start = parser.token.position();
	expr.ident.name.end = parser.token.position_end();

	advance(parser)!;

	return expr;
}