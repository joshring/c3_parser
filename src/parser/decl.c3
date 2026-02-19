module c3_parser::parser;
import c3_parser::ast;
import c3::lexer;

fn Decl* decl_alloc(Parser* parser)
{
	parser.decls.push((Decl){});
	return &parser.decls[parser.decls.len() - 1];
}

fn void? parse_module(Parser* parser)
{
	
}

fn Decl*? parse_function(Parser* parser)
{
	assert(parser.token.type == TokenType.FUNC);
	advance(parser)!;

	Decl* decl = decl_alloc(parser);
	
	decl.type = DeclType.FUNC;
	


	return decl;
}
