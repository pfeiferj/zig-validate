const std = @import("std");
const testing = std.testing;
const slice = @import("slice.zig");
const scalar = @import("scalar.zig");
const Validator = @import("validator.zig").Validator;
const combinator = @import("combinator.zig");

pub fn validate(comptime D: type, comptime v: anytype, d: D) bool {
    comptime var vt = @typeInfo(@TypeOf(v));
    var valid = true;

    switch (vt) {
        .Struct => {
            comptime var fds = fields(@TypeOf(v));

            inline for (fds) |field| {
                const data = @field(d, field);
                comptime var dt = @TypeOf(data);
                comptime var ti = @typeInfo(dt);
                if (ti == .Struct) {
                    valid = valid and validate(dt, @field(v, field), data);
                    continue;
                }
                const fieldValid = @field(v, field).call(dt, data);
                valid = valid and fieldValid;
            }
            return valid;
        },
        else => return false,
    }
}

test "validate example" {
    comptime var ValidateData = struct { a: *const Validator, b: *const Validator, c: struct {
        d: *const Validator,
    } };

    comptime var vd = ValidateData{ .a = &slice.regex_match("ao.*"), .b = &combinator._and(&.{ &scalar.min(u8, 3), &scalar.max(u8, 7) }), .c = .{
        .d = &combinator._or(&.{ &slice.min_length(3), &slice.equals(&[_]u32{ 1, 2 }) }),
    } };

    comptime var Data = struct { a: [:0]const u8, b: u8, c: struct {
        d: []const u32,
        e: []const f32,
    } };

    const d = Data{ .a = "aoeu", .b = 4, .c = .{
        .d = &[_]u32{ 1, 2 },
        .e = &[_]f32{ 1, 2 },
    } };
    const d2 = Data{ .a = "aolrcoeu", .b = 3, .c = .{
        .d = &[_]u32{1},
        .e = &[_]f32{1},
    } };

    try testing.expect(validate(Data, vd, d) == true);
    try testing.expect(validate(Data, vd, d2) == false);
}

fn fields(comptime T: type) [][]const u8 {
    const len = comptime @typeInfo(T).Struct.fields.len;

    comptime var names: [len][]const u8 = .{};

    comptime {
        var i = 0;
        const vtdInfo = @typeInfo(T).Struct.fields;
        for (vtdInfo) |field| {
            names[i] = field.name;
            i += 1;
        }
    }
    return &names;
}
