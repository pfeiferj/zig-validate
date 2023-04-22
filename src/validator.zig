const slice = @import("./slice.zig");
const scalar = @import("./scalar.zig");

pub const Validator = union(enum) {
    max_length: slice.MaxLength,
    min_length: slice.MinLength,
    min: scalar.Min,
    max: scalar.Max,

    pub fn call(self: *const Validator, comptime data: anytype) bool {
        return switch ((self.*)) {
            inline else => |case| case.call(data),
        };
    }
};
