const std = @import("std");
const testing = std.testing;
pub const slice = @import("slice.zig");
pub const scalar = @import("scalar.zig");
pub const combinator = @import("combinator.zig");
pub const log = @import("log.zig");

fn _Validator(comptime T: type, comptime pos: usize, comptime vdef: anytype) type {
    const tmp: T = undefined;
    const fields = @typeInfo(@TypeOf(vdef)).Struct.fields;
    const field_type = @TypeOf(@field(tmp, fields[pos].name));
    const validator = @field(vdef, fields[pos].name);

    comptime var v = blk: {
        const fti = @typeInfo(fields[pos].type);
        switch (fti) {
            .Struct => break :blk .{.{ fields[pos].name, Validator(field_type, validator).init() }},
            else => break :blk .{.{ fields[pos].name, validator.init() }},
        }
    };

    const tup = blk: {
        if (pos + 1 < fields.len) {
            break :blk v ++ _Validator(T, pos + 1, vdef).init().tup;
        } else {
            break :blk v;
        }
    };

    return struct {
        const Self = @This();
        tup: @TypeOf(tup),
        pub fn init() Self {
            return Self{
                .tup = tup,
            };
        }
    };
}

pub fn Validator(comptime T: type, comptime vdef: anytype) type {
    comptime var validators = blk: {
        const infoT = @typeInfo(@TypeOf(vdef));
        break :blk switch (infoT) {
            .Struct => _Validator(T, 0, vdef).init().tup,
            else => .{},
        };
    };

    return struct {
        const Self = @This();
        validators: @TypeOf(validators),

        pub fn init() Self {
            return Self{
                .validators = validators,
            };
        }

        pub fn validate(comptime self: @This(), comptime T2: type, value: T2) bool {
            var valid = true;
            inline for (self.validators) |validatorInfo| {
                const name = validatorInfo[0];
                const tmp: T2 = undefined;
                const T3 = @TypeOf(@field(tmp, name));
                const validator = validatorInfo[1];
                const next_value = @field(value, name);
                valid = valid and validator.validate(T3, next_value);
            }
            return valid;
        }
    };
}

test "validate example" {
    const Data = struct {
        a: u8,
        b: f64,
        c: struct {
            d: bool,
            e: []const u8,
        },
    };

    comptime var dataValidator = Validator(Data, .{ .a = scalar.Equals(2), .b = combinator.And(
        scalar.Min(6.7),
        scalar.Max(6.9),
    ), .c = .{
        .e = slice.RegexMatch("[a-zA-Z]+"),
    } }).init();

    const d = Data{
        .a = 2,
        .b = 6.8,
        .c = .{
            .d = true,
            .e = "abc",
        },
    };

    try testing.expect(dataValidator.validate(Data, d) == true);
}
