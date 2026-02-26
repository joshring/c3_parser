module c3_parser;
import c3::lexer;
import utils::ast;
import std::io;
import c3_parser::parser;

char[*] test_file = $embed("../test/test_file.c3");

fn int main(String[] args)
{
	String src = (String)&test_file;

	log::set_priority_all(LogPriority.VERBOSE);

	Lexer lexer;
	lexer.init(src);

	Parser parser = (Parser){ 
		.lexer = lexer,
	};

	parser::init(&parser);
	defer parser::free(&parser);

	if (catch err = parser::parse(&parser))
	{
		log::error("%s", err);
	}
	
	ast::dump(parser.ast, src);
	
	return 0;
}
