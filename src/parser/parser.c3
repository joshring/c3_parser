module c3_parser::parser;

import c3::lexer;
import c3_parser::ast;
import std::collections::list;
import handle_pool;
import handle;

faultdef 
	CONTRACT_NOT_ALLOWED,
	PARSER_EOF
;

struct Parser
{
	HandlePool{ Decl } decls;
	HandlePool{ Expr } exprs;
	HandlePool{ Stmt } stmts;

	Lexer lexer;
	Token token;
	Allocator alloc;
}

fn void init(Parser* parser)
{
	parser.decls.init(parser.alloc);
	parser.exprs.init(parser.alloc);
	parser.stmts.init(parser.alloc);
}

fn void free(Parser* parser)
{
	parser.decls.free();
	parser.exprs.free();
	parser.stmts.free();
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

fn void? parse(Parser* parser)
{
	// prime
	if (catch err = advance(parser))
	{
		log::debug("couldn't advance");
		return err~;
	}
	if (catch err = advance(parser))
	{
		log::debug("couldn't advance");
		return err~;
	}

	while (!token_is(parser, TokenType.EOF))
	{
		Decl*? decl = parse_top_level_statement(parser);
		if (catch advance(parser))
		{
			return;
		}

		if (catch decl)
		{
			continue;
		}

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
		if (try advance(parser))
		{
			
		}	
		break;
	default:
		break;
	}

	return null;
}