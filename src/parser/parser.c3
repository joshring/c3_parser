module c3_parser::parser;

import c3::lexer;
import c3_parser::ast;
import c3_parser::mod;

import std::collections::list;
import std::io;

faultdef 
	CONTRACT_NOT_ALLOWED,
	UNEXPECTED_TOKEN,
	FOUND_MODULE,
	PARSER_EOF
;

struct Parser
{
	Lexer lexer;
	ModuleSection* section;
	String src;
	Token token;
}

fn bool Parser.eof(&self) @inline 
{
	return token_is(self, TokenType.EOF);
}

fn bool token_is(Parser* parser, TokenType type) @inline 
{
	return parser.token.type == type;
}

fn void? advance(Parser* parser)
{
	if (parser.eof())
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

fn Ident Parser.ident(&self, AstPosition start, AstPosition end)
{
	Ident ident = (Ident){
		.range.start = start,
		.range.end = end,
	};

	if (!@ok(@try(ident.name, ident.range.slice_text(self.src))))
	{
		ident.name = "";
	}

	return ident;
}

fn void? parse(Parser* parser)
{
	while (!parser.eof())
	{
		Decl*? decl = parse_top_level_statement(parser);

		if (catch err = decl)
		{
			if (err == FOUND_MODULE)
			{
				return FOUND_MODULE~;
			}
			else
			{
				continue;
			}
		}

		advance(parser)!;

		if (decl == null) continue;
		(void)parser.section.ast.decls.push(decl);
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
		return FOUND_MODULE~;
	case TokenType.IMPORT: 
		decl = parse_import(parser)!;
	default:
		break;
	}

	return decl;
}