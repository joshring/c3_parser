module utils::ast;

import c3_parser::ast;
import std::io;
import std::collections::list;

fn void print_prefix(String prefix, bool is_last)
{
    io::print(prefix);

    if (is_last)
	{
        io::print("└─ ");
	}
    else
	{
        io::print("├─ ");
	}
}

fn String make_child_prefix(String prefix, bool is_last)
{
    if (is_last)
	{
        return prefix.tconcat("   ");
	}
    else
	{
        return prefix.tconcat("│  ");
	}
}

fn void indent(int depth) @private
{
    for (int i = 0; i < depth; i++)
    {
        io::print("  ");
    }
}

fn void dump(Ast* ast, String src)
{
	int count = (int)ast.decls.len();

   	for (int i = 0; i < count; i++)
    {
        bool is_last = (i == count - 1);
        print_decl(ast.decls[i], "", is_last, src);
    }
}

fn void print_decl(Decl* decl, String prefix, bool is_last, String src)
{
    print_prefix(prefix, is_last);

    switch (decl.type)
    {
        case FUNC:
        {
            (void)io::printf("FuncDecl: %s\n",
                decl.name.slice_text(src));

            String child_prefix = make_child_prefix(prefix, is_last);
            print_func_decl(&decl.func, child_prefix, src);
            break;
        }

        case MODULE:
        {
            (void)io::printf("ModuleDecl: %s\n",
                decl.mod.name.slice_text(src));
            break;
        }

        case IMPORT:
        {

            (void)io::printf("ImportDecl: %s\n",
                decl.name.slice_text(src));
            break;
        }
    }
}

fn void print_func_decl(FuncDecl* decl, String prefix, String src)
{
    int child_count = FuncDecl.membersof.len;

    // --- Return Type ---
    print_prefix(prefix, false);
    (void)io::printfn("RetType: %s", decl.ret_type.slice_text(src));

    // --- Args ---
    print_prefix(prefix, false);
    (void)io::printfn("Args: %s", decl.args.slice_text(src));

    // --- Block ---
    print_prefix(prefix, true);
    io::print("Block\n");

    if (decl.block != null)
    {
        String child_prefix = make_child_prefix(prefix, true);
        print_stmt(decl.block, child_prefix, true, src);
    }
}

fn void print_stmt(Stmt* stmt, String prefix, bool is_last, String src)
{
    print_prefix(prefix, is_last);

    switch (stmt.type)
    {
        case RETURN:
        {
            io::print("ReturnStmt\n");

			String child_prefix = make_child_prefix(prefix, is_last);
			(void)io::printf("%s", child_prefix);
		
            break;
        }
        default:
            io::print("Stmt\n");
            break;
    }
}

fn void print_expr(Expr* expr, String prefix, bool is_last, String src)
{
    print_prefix(prefix, is_last);

    switch (expr.type)
    {
        default:
            io::print("Expr\n");
            break;
    }
}