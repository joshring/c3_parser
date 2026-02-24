module c3_parser::parser;

import c3::lexer;
import c3_parser::ast;
import std::collections::list;
import std::io;

faultdef 
	CONTRACT_NOT_ALLOWED,
	UNEXPECTED_TOKEN,
	PARSER_EOF
;

struct Parser
{
	Lexer lexer;
	Ast* ast;
	Token token;
}

fn void init(Parser* parser)
{
	parser.ast = mem::tnew(Ast);

	parser.ast.decls.init(tmem);
}

fn void free(Parser* parser)
{

}

fn bool token_is(Parser* parser, TokenType type) @inline 
{
	return parser.token.type == type;
}

fn void? advance(Parser* parser)
{
	if (token_is(parser, TokenType.EOF))
	{
		return PARSER_EOF~;
	}

	parser.token = parser.lexer.next()!;
}

fn void? expect(Parser* parser, TokenType type)
{
	if (!token_is(parser, type))
	{
		return UNEXPECTED_TOKEN~;
	}
}

fn bool? consume(Parser* parser, TokenType type)
{
	if (token_is(parser, type))
	{
		advance(parser)!;
		return true;
	}

	return false;
}

fn void? parse(Parser* parser)
{
	// prime
	advance(parser)!;

	while (!token_is(parser, TokenType.EOF))
	{
		Decl*? decl = parse_top_level_statement(parser);
		advance(parser)!;

		if (catch err = decl)
		{
			continue;
		}

		if (decl == null) continue;
		parser.ast.decls.push(decl);
	}
}

fn Decl*? parse_top_level_statement(Parser* parser)
{
	Decl* decl;

	TokenType type = parser.token.type;
	bool attach_contracts = false;

	switch (type)
	{
	case TokenType.FUNC:
		decl = parse_function(parser)!;
		break;
	case TokenType.MODULE:
		decl = parse_module(parser)!;
		break;
	default:
		break;
	}

	return decl;
}