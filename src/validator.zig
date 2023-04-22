const slice = @import("./slice.zig");
const scalar = @import("./scalar.zig");
const combinator = @import("./combinator.zig");

pub const Validator = union(enum) {
    max_length: slice.MaxLength,
    min_length: slice.MinLength,
    min: scalar.Min,
    max: scalar.Max,
    _and: combinator.And,

    pub fn call(self: *const Validator, comptime data: anytype) bool {
        return switch ((self.*)) {
            inline else => |case| case.call(data),
        };
    }
};

pub const end = Validator{ .end = 0 };
