module c3_parser::parser;

import c3_parser::ast;
import c3::lexer;

fn Stmt*? parse_block(Parser* parser)
{
 	if (catch expect(parser, TokenType.LBRACE))
	{
		// TODO: what error msg?
		log::error("invalid 'body' no LBRACE");
		return UNEXPECTED_TOKEN~;
	}

	Stmt* stmt = mem::tnew(Stmt);

	stmt.block.body.start = parser.token.position();

	// advance aw from '{'
	advance(parser)!;

	Lexer temp_lexer = parser.lexer;
	Token token @noinit;
	do
	{
		token = temp_lexer.next()!;
	} 
	while (token.type != TokenType.RBRACE);

	stmt.block.body.end = token.position_end();

	return stmt;
}

