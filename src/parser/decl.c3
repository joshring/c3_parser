module c3_parser::parser;
import c3_parser::ast;
import c3::lexer;

fn void? parse_module(Parser* parser)
{
	
}

fn Decl*? parse_function(Parser* parser)
{
	if (!consume(parser, TokenType.FUNC)!)
	{
		log::error("expected 'fn'");
		return UNEXPECTED_TOKEN~;
	}

	Decl* decl = mem::tnew(Decl);
	decl.type = DeclType.FUNC;
	
	//TODO: parse type
	if (token_is(parser, TokenType.TYPE_IDENT))
	{
		consume(parser, TokenType.TYPE_IDENT)!;
	}

	decl.func.ret_type.start = parser.token.position();
	decl.func.ret_type.end = parser.token.position_end();

	advance(parser)!;

	// parse name
	expect(parser, TokenType.IDENT)!;
	
	decl.name.start = parser.token.position();
	decl.name.end = parser.token.position_end();

	if (!consume(parser, TokenType.IDENT)!)
	{
		log::error("expected 'Identifier' after Type");
		return UNEXPECTED_TOKEN~;
	}

	consume(parser, TokenType.LPAREN)!;

	decl.func.args.start = parser.token.position();

	// just simulate parsing args for now
	while (!token_is(parser, TokenType.RPAREN))
	{
		advance(parser)!;
	}

	decl.func.args.end = parser.token.position_end();

	advance(parser)!;

	// skip last paren

	if (token_is(parser, TokenType.LBRACE))
	{
		decl.func.block = parse_block(parser)!;
	}

	return decl;
}
