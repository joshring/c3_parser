module c3_parser;
import c3::lexer;

import std::io;

const String TEST_STRING = "module test::new;\nfn void parse (Type type);";
fn int main(String[] args)
{
	Lexer lexer;
	lexer.init(TEST_STRING);
	AstNode node;
	lexer = node.parse(lexer)!!;
	io::printn(node.to_string(tmem, TEST_STRING)!!);
	lexer = node.parse(lexer)!!;
	io::printn(node.to_string(tmem, TEST_STRING)!!);
	return 0;
}
