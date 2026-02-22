module c3_parser::parser;

import c3_parser::ast;
import c3::lexer;

fn StmtHandle stmt_alloc(Parser* parser)
{
	return parser.stmts.create();
}

fn StmtHandle? parse_body(Parser* parser)
{
 	if (catch expect(parser, TokenType.LBRACE))
	{
		// TODO: what error msg?
		log::error("invalid 'body' no LBRACE");
		return UNEXPECTED_TOKEN~;
	}

	StmtHandle handle = stmt_alloc(parser);
	Stmt* stmt = parser.stmts.get_ref(handle);

	stmt.body.body.start = parser.token.position();

	do 
	{
		advance(parser)!;
	} 
	while (parser.token.type != TokenType.RBRACE);

	stmt.body.body.end = parser.token.position_end();

	return handle;
}

