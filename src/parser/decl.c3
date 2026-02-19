module c3_parser::parser;
import c3_parser::ast;
import c3::lexer;

fn AstNodeDecl? Lexer.parse_decl(&self)
{
	Lexer old_lexer = *self;
	defer catch *self = old_lexer;

	if (try module_decl = self.parse_module())
	{
		return module_decl;
	}
	else if (try func_decl = self.parse_function())
	{
		func_decl.type = AstNodeDeclType.FUNC;
		return func_decl;
	}
	log::debug("Failed to parse decl");
	return INCOMPATIBLE?;
}
<*
	TODO: parse attributes, generic syntax
*>
fn AstNodeDecl? Lexer.parse_module(&self)
{
	Lexer old_lexer = *self;
	defer catch *self = old_lexer;

	AstNodeDecl decl = {
		.type = AstNodeDeclType.MODULE,
	};

	Token token @noinit;
	if (!@ok(@try(token, self.next())))
	{
		log::debug("Lexer next() failed");
		return INCOMPATIBLE?!;
	}
	if (token.type != TokenType.MODULE)
	{
		log::debug("Token isn't module");
		return INCOMPATIBLE?;
	}
	if (!@ok(@try(token, self.next())))
	{
		log::debug("Lexer next() failed");
		return INCOMPATIBLE?!;
	}
	decl.name.start = token.position();
	Lexer temp_lexer = *self;
	while LOOP: (@ok(@try(token, temp_lexer.next())))
	{
		switch (token.type)
		{
			case IDENT:
			case SCOPE:
				decl.name.end = token.position_end();
			default:
				break LOOP;
		}
		*self = temp_lexer;
	}
	return decl;
}
<*
	TODO: parse args into list, method, attributes, generic syntax
*>
fn AstNodeDecl? Lexer.parse_function(&self)
{
	Lexer old_lexer = *self;
	defer catch *self = old_lexer;

	AstNodeDecl decl = {
		.type = AstNodeDeclType.FUNC,
	};

	Token token @noinit;
	if (!@ok(@try(token, self.next())))
	{
		log::debug("Lexer next() failed");
		return INCOMPATIBLE?!;
	}
	if (token.type != TokenType.FUNC)
	{
		log::debug("Token isn't func");
		return INCOMPATIBLE?;
	}
	if (!@ok(@try(token, self.next())))
	{
		log::debug("Lexer next() failed");
		return INCOMPATIBLE?!;
	}
	decl.func.ret_type.start = token.position();
	decl.func.ret_type.end = token.position_end();
	if (!@ok(@try(token, self.next())))
	{
		log::debug("Lexer next() failed");
		return INCOMPATIBLE?!;
	}
	decl.name.start = token.position();
	decl.name.end = token.position_end();
	Lexer temp_lexer = *self;
	while LOOP: (@ok(@try(token, temp_lexer.next())))
	{
		switch (token.type)
		{
			case LPAREN:
				decl.func.args.start = token.position_end();
			case RPAREN:
				decl.func.args.end = token.position_end();
				*self = temp_lexer;
				break LOOP;
			default:
				break;
		}
		*self = temp_lexer;
	}
	return decl;
}
