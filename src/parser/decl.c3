module c3_parser::parser;
import c3_parser::ast;
import c3::lexer;

import c3_parser::common;

fn Decl*? parse_module(Parser* parser)
{
	if (!consume(parser, TokenType.MODULE)!)
	{
		parser.error("expected 'module'");
		return UNEXPECTED_TOKEN~;
	}

	Decl* decl = mem::tnew(Decl);
	decl.type = DeclType.MODULE;

	expect(parser, TokenType.IDENT)!;

	SourceSpan start = parser.span;
	SourceSpan end @noinit;

	while (true) 
	{
		end = parser.span;

		if (!consume(parser, TokenType.IDENT)!)
		{
			parser.error("expected a valid identifier");
			return UNEXPECTED_TOKEN~;
		}

		if (!consume(parser, TokenType.SCOPE)!)
		{
			break;
		}
	}

	decl.span = start.combine(end);

	expect(parser, TokenType.EOS)!;
	advance(parser)!;

	return decl;
}

fn Decl*? parse_import(Parser* parser)
{
	if (!consume(parser, TokenType.IMPORT)!)
	{
		parser.error("expected 'import");
		return UNEXPECTED_TOKEN~;
	}

	Decl* decl = mem::tnew(Decl);
	decl.type = DeclType.IMPORT;

	SourceSpan start = parser.span;
	SourceSpan end @noinit;

	while (true) 
	{
		end = parser.span;

		if (!consume(parser, TokenType.IDENT)!)
		{
			parser.error("expected a valid identifier");
			return UNEXPECTED_TOKEN~;
		}

		if (!consume(parser, TokenType.SCOPE)!)
		{
			break;
		}
	}

	decl.span = start.combine(end);

	expect(parser, TokenType.EOS)!;
	advance(parser)!;

	return decl;
}

fn Decl*? parse_function(Parser* parser)
{
	if (!consume(parser, TokenType.FUNC)!)
	{
		parser.error("Expected 'fn'");
		return UNEXPECTED_TOKEN~;
	}

	Decl* decl = mem::tnew(Decl);
	decl.type = DeclType.FUNC;
	
	//TODO: parse type
	if (token_is(parser, TokenType.TYPE_IDENT))
	{
		consume(parser, TokenType.TYPE_IDENT)!;
	}

	decl.func.ret_type = parser.ident();
	
	advance(parser)!;

	// parse name
	expect(parser, TokenType.IDENT)!;
	
	decl.name = parser.ident();

	if (!consume(parser, TokenType.IDENT)!)
	{
		parser.error("expected 'Identifier' after Type");
		return UNEXPECTED_TOKEN~;
	}

	consume(parser, TokenType.LPAREN)!;

	SourceSpan start = parser.span;

	// just simulate parsing args for now
	while (!token_is(parser, TokenType.RPAREN))
	{
		advance(parser)!;
	}

	SourceSpan end = parser.span;

	decl.func.args = start.combine(end);

	advance(parser)!;

	// skip last paren

	if (token_is(parser, TokenType.LBRACE))
	{
		decl.func.block = parse_block(parser)!;
	}

	return decl;
}

fn Decl*? parse_global_decl(Parser* parser)
{
	bool is_thread_local = consume(parser, TokenType.TLOCAL)!;

	if (token_is(parser, TokenType.CONST_IDENT))
	{
		parser.error("Expected ''");
		return UNEXPECTED_TOKEN~;
	}

	Decl* decl = mem::tnew(Decl);
	decl.type = DeclType.FUNC;

	return decl;
}