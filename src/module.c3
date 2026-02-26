module c3_parser::mod;

import c3_parser::ast;

import std::collections::list;

struct Module
{
    String module_name;
    List{ ModuleSection* } sections;
}
