module test::new;

import std::io;

fn void parse(uint value)
{
	io::printn("foo");
}

fn int foo(uint value)
{
	return 0;
}

void* type;


module foo::bar;

import std::io;

fn void test(char arg)
{
	io::printn("hello there");
}
