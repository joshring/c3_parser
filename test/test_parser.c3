module test @test;

import c3_parser;
import std::io;
import c3::lexer;

char[*] test_file = $embed("test_file.c3");

// WIP output with: 	c3c test --test-show-output
fn void test_parser()
{
	String src = (String)&test_file;

	log::set_priority_all(LogPriority.VERBOSE);

	DynamicArenaAllocator alloc = (DynamicArenaAllocator){};
	alloc.init(mem, AstNode.sizeof * 1000);
	defer alloc.free();

	Lexer lexer;
	lexer.init(src);

	Parser parser = (Parser){ 
		.lexer = lexer,
		.alloc = &alloc,
	};

	if (catch err = parser::parse(&parser))
	{
		log::debug("%s", err);
	}
}