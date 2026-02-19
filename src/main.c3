module c3_parser;
import c3::lexer;

import std::io;

const String TEST_STRING = `module test::new;
fn void parse (Type type);
Type type;
`;
fn int main(String[] args)
{
	log::set_priority_all(LogPriority.VERBOSE);
	Lexer lexer;
	lexer.init(TEST_STRING);
	while (true)
	{
		if (try node = lexer.parse_ast())
		{
			io::printn(node.to_string(tmem, TEST_STRING)!!);
		}
		else if (catch lexer.next())
		{
			break;
		}
	}
	return 0;
}
