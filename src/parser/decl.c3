module c3_parser::parser;
import c3_parser::ast;
import c3::lexer;

fn Decl*? parse_module(Parser* parser)
{
	if (!consume(parser, TokenType.MODULE)!)
	{
		log::error("expected 'module'");
		return UNEXPECTED_TOKEN~;
	}

	Decl* decl = mem::tnew(Decl);
	decl.type = DeclType.MODULE;

	if (!token_is(parser, TokenType.IDENT))
	{
		log::error("expected 'Identifier', got %s", parser.token.text);
		return UNEXPECTED_TOKEN~;
	}

	AstPosition start = parser.token.position();

	//TODO: better way?
	do 
	{
		advance(parser)!;
	} 
	while (token_is(parser, TokenType.IDENT) || token_is(parser, TokenType.SCOPE));

	AstPosition end = parser.token.position();
	
	decl.mod.name = parser.ident(start, end);

	expect(parser, TokenType.EOS)!;

	return decl;
}

fn Decl*? parse_import(Parser* parser)
{
	if (!consume(parser, TokenType.IMPORT)!)
	{
		log::error("expected 'import");
		return UNEXPECTED_TOKEN~;
	}

	Decl* decl = mem::tnew(Decl);
	decl.type = DeclType.IMPORT;

	AstPosition start = parser.token.position();

	do 
	{
		advance(parser)!;
	} 
	while (token_is(parser, TokenType.IDENT) || token_is(parser, TokenType.SCOPE));

	AstPosition end = parser.token.position();

	decl.imp.name = parser.ident(start, end);

	return decl;
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

	decl.func.ret_type = parser.ident(parser.token.position(), parser.token.position_end());
	
	advance(parser)!;

	// parse name
	expect(parser, TokenType.IDENT)!;
	
	decl.name = parser.ident(parser.token.position(), parser.token.position_end());

	if (!consume(parser, TokenType.IDENT)!)
	{
		log::error("expected 'Identifier' after Type");
		return UNEXPECTED_TOKEN~;
	}

	consume(parser, TokenType.LPAREN)!;

	AstPosition start = parser.token.position();

	// just simulate parsing args for now
	while (!token_is(parser, TokenType.RPAREN))
	{
		advance(parser)!;
	}

	AstPosition end = parser.token.position_end();

	decl.func.args = parser.ident(start, end);

	advance(parser)!;

	// skip last paren

	if (token_is(parser, TokenType.LBRACE))
	{
		decl.func.block = parse_block(parser)!;
	}

	return decl;
}