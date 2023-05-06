const std = @import("std");
const testing = std.testing;
const slice = @import("slice.zig");
const scalar = @import("scalar.zig");
const combinator = @import("combinator.zig");
const log = @import("log.zig");

pub fn validate(comptime v: anytype, d: anytype) bool {
    comptime var vt = @typeInfo(@TypeOf(v));
    var valid = true;

    switch (vt) {
        .Struct => {
            inline for (vt.Struct.fields) |field| {
                const fName = field.name;
                const data = @field(d, fName);
                comptime var dt = @TypeOf(data);
                comptime var ti = @typeInfo(dt);
                if (ti == .Struct) {
                    valid = valid and validate(@field(v, fName), data);
                    continue;
                }
                const fieldValid = @field(v, fName).call(data);
                valid = valid and fieldValid;
            }
            return valid;
        },
        else => return false,
    }
}

test "validate example" {
    comptime var ValidateData = .{
        .a = combinator._or(.{ scalar.equals(2), scalar.equals(6) }),
        .b = combinator._and(.{ scalar.min(3), scalar.max(7.2) }),
        .c = .{
            .d = scalar.equals(true),
            .e = log.failure(slice.min_length(3), std.log.err, "String must be at least 3 characters."),
        },
    };

    const Data = struct {
        a: u8,
        b: f64,
        c: struct {
            d: bool,
            e: []const u8,
        },
    };

    const d = Data{
        .a = 2,
        .b = 6.8,
        .c = .{
            .d = true,
            .e = "abc",
        },
    };

    try testing.expect(validate(ValidateData, d) == true);
}
