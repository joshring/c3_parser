module c3_parser::parser;

import c3_parser::ast;
import c3::lexer;
import c3_parser::common;

fn Stmt*? parse_block(Parser* parser)
{
 	if (catch expect(parser, TokenType.LBRACE))
	{
		// TODO: what error msg?
		parser.error("invalid 'body' no LBRACE");
		return UNEXPECTED_TOKEN~;
	}

	Stmt* stmt = mem::tnew(Stmt);
	stmt.type = StmtType.BLOCK;

	SourceSpan start = parser.span;

	// advance away from '{'
	advance(parser)!;

	Lexer temp_lexer = parser.lexer;
	Token token @noinit;
	do
	{
		token = temp_lexer.next()!;
	} 
	while (token.type != TokenType.RBRACE);

	stmt.block.body = start.combine(parser.span);

	return stmt;
}

fn Stmt*? parse_defer(Parser* parser)
{
	if (catch expect(parser, TokenType.DEFER))
	{
		// TODO: what error msg?
		parser.error("Expected 'defer'");
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
			parser.error("Expected 'catch' after 'defer ('");
			return UNEXPECTED_TOKEN~;
		}

		if (catch expect(parser, TokenType.IDENT))
		{
			parser.error("Expected 'Identifier' after catch");
			return UNEXPECTED_TOKEN~;
		}

		advance(parser)!;

		if (catch expect(parser, TokenType.RPAREN))
		{
			parser.error("Expected a closing ')' after 'Identifier");
			return UNEXPECTED_TOKEN~;
		}

		advance(parser)!;

		stmt.defer_stmt.block = parse_block(parser)!;
		stmt.defer_stmt.is_catch = true;
	}

	return stmt;
}