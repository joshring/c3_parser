module c3_parser::parser;
import c3_parser::ast;
import c3::lexer;

fn DeclHandle decl_alloc(Parser* parser)
{
	return parser.decls.create();
}

fn void? parse_module(Parser* parser)
{
	
}

fn Decl*? parse_function(Parser* parser)
{
	assert(parser.token.type == TokenType.FUNC);
	advance(parser)!;

	DeclHandle handle = decl_alloc(parser);
	Decl* decl = parser.decls.get(handle);
	assert(decl != null);
	
	decl.type = DeclType.FUNC;
	


	return decl;
}
