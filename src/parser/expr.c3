module c3_parser::parser;
import c3_parser::ast;
import c3::lexer;

fn Lexer? AstNodeExpr.parse(&self, Lexer lexer)
{
	Lexer new_lexer;
	switch
	{
	case @ok(@try(new_lexer, self.parse_ident(lexer))):
		self.type = AstNodeExprType.IDENT;
	case @ok(@try(new_lexer, self.parse_type_ident(lexer))):
		self.type = AstNodeExprType.TYPE_IDENT;
	default:
		log::debug("Failed to parse expr");
		return INCOMPATIBLE?;
	}
	return new_lexer;
}

fn Lexer? AstNodeExpr.parse_ident(&self, Lexer lexer)
{
	Token token @noinit;
	if (!@ok(@try(token, lexer.next())))
	{
		log::debug("Lexer next() failed");
		return INCOMPATIBLE?!;
	}
	if (token.type != IDENT)
	{
		log::debug("Token not recognized as type ident: %s", token);
		return INCOMPATIBLE?;
	}
	self.ident.name.start = token.position();
	self.ident.name.end = token.position_end();
	return lexer;
}
const TokenType[] AST_TYPE_IDENT_TOKENS @local = {
	VOID, BOOL, CHAR, ICHAR, SHORT, USHORT, INT, UINT, LONG, ULONG, INT128,
	UINT128, FLOAT, DOUBLE, FLOAT16, BFLOAT16, FLOAT128, IPTR, UPTR, ISZ,
	USZ, FAULT, ANY, TYPEID,
	TYPE_IDENT,
};
<*
	This treats every language type as a "type ident" even if it's a base type.
	Probably not a problem but might want to revisit.
	TODO: Parse generic syntax, requires parsing for constants
*>
fn Lexer? AstNodeExpr.parse_type_ident(&self, Lexer lexer)
{
	Token token @noinit;
	if (!@ok(@try(token, lexer.next())))
	{
		log::debug("Lexer next() failed");
		return INCOMPATIBLE?!;
	}
	if (!array::contains(AST_TYPE_IDENT_TOKENS, token.type))
	{
		log::debug("Token not recognized as type ident: %s", token);
		return INCOMPATIBLE?;
	}
	self.type_ident.type.start = token.position();
	self.type_ident.type.end = token.position_end();
	return lexer;
}
