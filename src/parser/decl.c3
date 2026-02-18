module c3_parser::parser;
import c3_parser::ast;
import c3::lexer;

fn Lexer? AstNodeDecl.parse(&self, Lexer lexer)
{
	if (try new_lexer = self.parse_module(lexer))
	{
		self.type = AstNodeDeclType.MODULE;
		return new_lexer;
	}
	else if (try new_lexer = self.parse_function(lexer))
	{
		self.type = AstNodeDeclType.FUNC;
		return new_lexer;
	}
	return INCOMPATIBLE?;
}
<*
	TODO: parse attributes, generic syntax
*>
fn Lexer? AstNodeDecl.parse_module(&self, Lexer lexer)
{
	Token token = lexer.next() ?? INCOMPATIBLE?!;
	if (token.type != TokenType.MODULE) return INCOMPATIBLE?;
	token = lexer.next() ?? INCOMPATIBLE?!;
	self.name.start = token.position();
	Lexer temp_lexer = lexer;
	while LOOP: (@ok(@try(token, temp_lexer.next())))
	{
		switch (token.type)
		{
			case IDENT:
			case SCOPE:
				self.name.end = token.position_end();
			default:
				break LOOP;
		}
		lexer = temp_lexer;
	}
	if (token.type == TokenType.EOS) lexer = temp_lexer;
	return lexer;
}
<*
	TODO: parse args into list, method, attributes, generic syntax
*>
fn Lexer? AstNodeDecl.parse_function(&self, Lexer lexer)
{
	Token token = lexer.next() ?? INCOMPATIBLE?!;
	if (token.type != TokenType.FUNC) return INCOMPATIBLE?;
	token = lexer.next() ?? INCOMPATIBLE?!;
	self.func.ret_type.start = token.position();
	self.func.ret_type.end = token.position_end();
	token = lexer.next() ?? INCOMPATIBLE?!;
	self.name.start = token.position();
	self.name.end = token.position_end();
	Lexer temp_lexer = lexer;
	while LOOP: (@ok(@try(token, temp_lexer.next())))
	{
		switch (token.type)
		{
			case LPAREN:
				self.func.args.start = token.position_end();
			case RPAREN:
				self.func.args.end = token.position_end();
				lexer = temp_lexer;
				break LOOP;
			default:
				break;
		}
		lexer = temp_lexer;
	}
	if (@ok(@try(token, temp_lexer.next())) && token.type == TokenType.EOS) lexer = temp_lexer;
	return lexer;
}
