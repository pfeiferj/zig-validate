const std = @import("std");
const testing = std.testing;
const slice = @import("slice.zig");
const scalar = @import("scalar.zig");
const Validator = @import("validator.zig").Validator;

pub fn validate(v: anytype, d: anytype) bool {
    comptime var vt = @typeInfo(@TypeOf(v));
    var valid = true;

    switch (vt) {
        .Struct => {
            comptime var fds = fields(@TypeOf(v));
            inline for (fds) |field| {
                const data = @field(d, field);
                const fieldValid = @field(v, field).call(@TypeOf(data), data);
                valid = valid and fieldValid;
            }
            return valid;
        },
        else => return false,
    }
}

test "poc" {
    const ValidateData = struct {
        a: *const Validator,
        b: *const Validator,
    };

    const vd = ValidateData{
        .a = &(slice.max_length(3)),
        .b = &(scalar.min(3)),
    };
    const Data = struct {
        a: []const u8,
        b: u8,
    };
    const d = Data{
        .a = "ab",
        .b = 4,
    };
    try testing.expect(validate(vd, d) == true);
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
