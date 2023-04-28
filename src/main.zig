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
                const fieldValid = @field(v, field).call(dt, data);
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

    //comptime var a_val = [_]*const Validator{ &slice.min_length(1), &slice.max_length(3), &slice.equals("ao") };
    comptime var b_val = [_]*const Validator{ &scalar.min(@as(u8, 3)), &scalar.max(@as(u8, 7)) };

    comptime var vd = ValidateData{
        .a = &slice.equals(&[_]u32{ 1, 2, 3 }),
        .b = &combinator._and(&b_val),
    };

    comptime var Data = struct {
        a: []const u32,
        b: u8,
    };

    const d = Data{
        .a = &[_]u32{ 1, 2, 3 },
        .b = 4,
    };
    const d2 = Data{
        .a = &[_]u32{ 1, 2, 3 },
        .b = 2,
    };

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
