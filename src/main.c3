module c3_parser;
import c3::lexer;

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

	foreach (Decl* decl : parser.ast.decls)
	{
		log::debug(decl.to_string(tmem, src)!!);
	}

	return 0;
}
