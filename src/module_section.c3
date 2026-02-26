module c3_parser::mod;

import c3_parser::ast;

struct ModuleSection
{
    String file_path;
    Ast* ast;
}