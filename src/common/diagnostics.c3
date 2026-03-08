module c3_parser::diagnostics;

import std::io;
import std::collections::list;

import c3_parser::common;

enum DiagnosticLevel 
{
    INFO,
    WARN,
    ERROR
}

struct FileEntry 
{
	String name;
	String source;
	List{ uint } line_starts;
}

Allocator alloc;
List{ FileEntry* } files;

fn void init(Allocator alloc)
{
	alloc = alloc;
	files.init(alloc);
}

fn void free()
{
	files.free();
}

<*
	add a file to be recognized by the diangostics.
	adds support to map a 'SourceSpan' to (line, culumn)
*>
fn FileID add_file(Allocator alloc, String name, String source)
{
	FileEntry* entry = allocator::new(alloc, FileEntry);
	entry.name = name;
	entry.source = source;

	entry.line_starts.init(alloc);
	entry.line_starts.push(0);
	
	for (uint i = 0; i < (uint)source.len; i++)
	{
		if (source[i] == '\n')
		{
			entry.line_starts.push(i + 1);
		}
	}

	files.push(entry);
	return (FileID)files.len() - 1;
}

fn Position get_pos(FileID id, uint offset)
{
	assert((usz)id < files.len());
	
	FileEntry* entry = files[(usz)id];

	// Binary search to find the line
    // We want the index of the largest value <= offset
	usz low = 0;
	usz high = entry.line_starts.len() - 1;
	usz line_index = 0;

	while (low <= high)
	{
		usz mid = low + (high - low) / 2;
		if (entry.line_starts[mid] <= offset)
		{
			line_index = mid;
			low = mid + 1;
		}
		else
		{
			high = mid - 1;
		}
	}

	return (Position){
		.line = line_index + 1,
		.column = (usz)offset - entry.line_starts[line_index] + 1
	};
}

fn String get_string(SourceSpan span)
{
	FileEntry* entry = files[(usz)span.file_id];
	assert(span.start < span.end);
	return entry.source[span.start..span.end];
}

fn void report_error(SourceSpan span, String msg)
{
	Position pos = get_pos(span.file_id, (uint)span.start);
    FileEntry* file = files[(usz)span.file_id];
    
    (void)io::printf("%s:%d:%d: Error: %s\n", file.name, pos.line, pos.column, msg);
}