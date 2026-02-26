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
	stmt.type = StmtType.BLOCK;

	stmt.block.body.start = parser.token.position();

	// advance away from '{'
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

fn Stmt*? parse_defer(Parser* parser)
{
	if (catch expect(parser, TokenType.DEFER))
	{
		// TODO: what error msg?
		log::error("Expected 'defer'");
		return UNEXPECTED_TOKEN~;
	}

	advance(parser)!;

	Stmt* stmt = mem::tnew(Stmt);
	stmt.type = StmtType.DEFER;

	if (consume(parser, TokenType.TRY)!)
	{
		stmt.defer_stmt.is_try = true;
	}
	else if (consume(parser, TokenType.CATCH)!)
	{
		stmt.defer_stmt.is_catch = true;
	}
	else if (token_is(parser, TokenType.LPAREN))
	{
		advance(parser)!;

		if (!consume(parser, TokenType.CATCH)!)
		{
			log::error("Expected 'catch' after 'defer ('");
			return UNEXPECTED_TOKEN~;
		}

		if (catch expect(parser, TokenType.IDENT))
		{
			log::error("Expected 'Identifier' after catch");
			return UNEXPECTED_TOKEN~;
		}

		advance(parser)!;

		if (catch expect(parser, TokenType.RPAREN))
		{
			log::error("Expected a closing ')' after 'Identifier");
			return UNEXPECTED_TOKEN~;
		}

		advance(parser)!;

		stmt.defer_stmt.block = parse_block(parser)!;
		stmt.defer_stmt.is_catch = true;
	}

	return stmt;
}