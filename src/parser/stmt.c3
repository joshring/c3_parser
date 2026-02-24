module c3_parser::parser;

import c3_parser::ast;
import c3::lexer;

fn StmtHandle stmt_alloc(Parser* parser)
{
	return parser.stmts.create();
}

fn StmtHandle? parse_block(Parser* parser)
{
 	if (catch expect(parser, TokenType.LBRACE))
	{
		// TODO: what error msg?
		log::error("invalid 'body' no LBRACE");
		return UNEXPECTED_TOKEN~;
	}

	StmtHandle handle = stmt_alloc(parser);
	Stmt* stmt = parser.stmts.get_ref(handle);

	stmt.block.body.start = parser.token.position();

	Lexer temp_lexer = parser.lexer;
	Token token @noinit;
	do
	{
		token = temp_lexer.next()!;
	} 
	while (token.type != TokenType.RBRACE);

	stmt.block.body.end = token.position_end();

	return handle;
}

