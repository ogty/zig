const print = std.debug.print;
const std = @import("std");
const os = std.os;
const assert = std.debug.assert;

pub fn main() anyerror!void {
    // $ zig build run -- arg1 arg2...
    const alloc = std.heap.page_allocator;
    var args = try std.process.argsAlloc(alloc);
    defer alloc.free(args);

    if (args.len > 1) {
        for (args) |arg, i| {
            if (i == 0) continue;
            print("{d}. {s}\n", .{ i, arg });
        }
    }

    try basis();
    divider();

    fizz_buzz();
    divider();

    print("{s}\n", .{hello_world()}); // Hello, world!
    print("{s}\n", .{read_file("./data/pangram.txt")});
    print("{s}\n", .{@TypeOf(read_file("./data/pangram.txt"))});
}

fn divider() void {
    print("{s}\n", .{"----------------------------------------"});
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
        print("{s}\n", .{line});
    }
}

fn basis() anyerror!void {
    const stdout = std.io.getStdOut().writer();
    try stdout.print("Hello, {s}!\n", .{"world"});

    print("Hello, world!\n", .{});

    // comment types
    // Normal Comments
    // /// Doc Comments
    // //! Top-Level Doc Comments

    // integers
    const one_plus_one: i32 = 1 + 1;
    print("1 + 1 = {d} | type: {s}", .{ one_plus_one, @typeName(@TypeOf(one_plus_one)) });

    // floats
    const seven_div_three: f32 = 7.0 / 3.0;
    print("7.0 / 3.0 = {}\n", .{seven_div_three});

    // boolean
    print("{}\n{}\n{}\n", .{
        true and false,
        true or false,
        !true,
    });
}

fn fizz_buzz() void {
    var i: usize = 1;
    while (i <= 100) : (i += 1) {
        if (i % 3 == 0 and i % 5 == 0) {
            print("FizzBuzz\n", .{});
        } else if (i % 3 == 0) {
            print("Fizz\n", .{});
        } else if (i % 5 == 0) {
            print("Buzz\n", .{});
        } else {
            print("{d}\n", .{i});
        }
    }
}
