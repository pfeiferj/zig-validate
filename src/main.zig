const std = @import("std");
const testing = std.testing;
const slice = @import("slice.zig");
const scalar = @import("scalar.zig");
const Validator = @import("validator.zig").Validator;
const combinator = @import("combinator.zig");

pub fn validate(v: anytype, comptime d: anytype) bool {
    comptime var vt = @typeInfo(@TypeOf(v));
    var valid = true;

    switch (vt) {
        .Struct => {
            comptime var fds = fields(@TypeOf(v));
            inline for (fds) |field| {
                const data = @field(d, field);
                const fieldValid = @field(v, field).call(data);
                valid = valid and fieldValid;
            }
            return valid;
        },
        else => return false,
    }
}

test "poc blah" {
    comptime var ValidateData = struct {
        a: *const Validator,
        b: *const Validator,
    };

    comptime var a_val = [_]*const Validator{ &slice.min_length(1), &slice.max_length(3) };
    comptime var b_val = [_]*const Validator{ &scalar.min(3), &scalar.max(7) };

    comptime var vd = ValidateData{
        .a = &combinator._and(&a_val),
        .b = &combinator._and(&b_val),
    };

    comptime var Data = struct {
        a: []const u8,
        b: u8,
    };

    const d = Data{
        .a = "ab",
        .b = 4,
    };
    const d2 = Data{
        .a = "ab",
        .b = 2,
    };

    try testing.expect(validate(vd, d) == true);
    try testing.expect(validate(vd, d2) == false);
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
