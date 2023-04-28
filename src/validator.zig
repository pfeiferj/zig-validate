const slice = @import("./slice.zig");
const scalar = @import("./scalar.zig");
const combinator = @import("./combinator.zig");

pub const Validator = union(enum) {
    max_length: slice.MaxLength,
    min_length: slice.MinLength,
    slice_equals: slice.Equals,
    min: scalar.Min,
    max: scalar.Max,
    _and: combinator.And,
    _or: combinator.Or,
    _xor: combinator.XOr,
    _not: combinator.Not,

    pub fn call(self: *const Validator, comptime D: type, data: D) bool {
        return switch ((self.*)) {
            inline else => |case| case.call(D, data),
        };
    }
};
