module c3_parser::parser;
import c3_parser::ast;
import c3::lexer;

fn AstNodeExpr? Lexer.parse_expr(&self)
{
	Lexer old_lexer = *self;
	defer catch *self = old_lexer;

	if (try ident = self.parse_ident())
	{
		return ident;
	}
	else if (try type_ident = self.parse_type_ident())
	{
		return type_ident;
	}
	log::debug("Failed to parse expr");
	return INCOMPATIBLE?;
}

fn AstNodeExpr? Lexer.parse_ident(&self)
{
	Lexer old_lexer = *self;
	defer catch *self = old_lexer;

	AstNodeExpr expr = {
		.type = AstNodeExprType.IDENT,
	};

	Token token @noinit;
	if (!@ok(@try(token, self.next())))
	{
		log::debug("Lexer next() failed");
		return INCOMPATIBLE?!;
	}
	if (token.type != IDENT)
	{
		log::debug("Token not recognized as type ident: %s", token);
		return INCOMPATIBLE?;
	}
	expr.ident.name.start = token.position();
	expr.ident.name.end = token.position_end();
	return expr;
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
fn AstNodeExpr? Lexer.parse_type_ident(&self)
{
	Lexer old_lexer = *self;
	defer catch *self = old_lexer;

	AstNodeExpr expr = {
		.type = AstNodeExprType.TYPE_IDENT,
	};

	Token token @noinit;
	if (!@ok(@try(token, self.next())))
	{
		log::debug("Lexer next() failed");
		return INCOMPATIBLE?!;
	}
	if (!array::contains(AST_TYPE_IDENT_TOKENS, token.type))
	{
		log::debug("Token not recognized as type ident: %s", token);
		return INCOMPATIBLE?;
	}
	expr.type_ident.type.start = token.position();
	expr.type_ident.type.end = token.position_end();
	return expr;
}
