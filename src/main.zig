const std = @import("std");

pub fn main() anyerror!void {
    // $ zig build run -- arg1 arg2...
    const alloc = std.heap.page_allocator;
    var args = try std.process.argsAlloc(alloc);
    defer alloc.free(args);

    if (args.len > 1) {
        for (args) |arg, i| {
            if (i == 0) continue;
            std.debug.print("{d}. {s}\n", .{i, arg});
        }
    }

    std.debug.print("{s}\n", .{hello_world()});
    std.debug.print("{s}\n", .{read_file("./data/pangram.txt")});
}

fn hello_world() []const u8 {
    return "Hello, world!";
}

fn read_file(path: []const u8) anyerror!void {
    var file = try std.fs.cwd().openFile(path, .{});
    defer file.close();

    var buf_reader = std.io.bufferedReader(file.reader());
    var in_stream = buf_reader.reader();

    var buf: [1024]u8 = undefined;
    while (try in_stream.readUntilDelimiterOrEof(&buf, '\n')) |line| {
        std.debug.print("{s}\n", .{line});
    }
}
