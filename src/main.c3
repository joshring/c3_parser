module c3_parser;
import c3::lexer;

import std::io;
import c3_parser::parser;

char[*] test_file = $embed("../test/test_file.c3");

fn int main(String[] args)
{
	String src = (String)&test_file;

	log::set_priority_all(LogPriority.VERBOSE);

	DynamicArenaAllocator alloc = (DynamicArenaAllocator){};
	alloc.init(mem, 1000);
	defer alloc.free();

	Lexer lexer;
	lexer.init(src);

	Parser parser = (Parser){ 
		.lexer = lexer,
		.alloc = &alloc,
	};

	parser::init(&parser);
	defer parser::free(&parser);

	if (catch err = parser::parse(&parser))
	{
		log::debug("%s", err);
	}

	parser.decls.@each(; Decl* decl)
	{
		log::debug("Decl -> %s", decl.type);
	};

	return 0;
}
