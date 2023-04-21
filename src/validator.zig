const Sl = @import("./slice.zig");
const Sc = @import("./scalar.zig");

pub const Validator = union(enum) {
    slice: Sl.Slice,
    scalar: Sc.Scalar,

    pub fn call(self: *const Validator, comptime T: type, data: T) bool {
        return switch ((&comptime @typeInfo(T)).*) {
            .Array, .Pointer, .Vector => switch ((&self.slice).*) {
                inline else => |*scase| scase.call(T, data),
            },
            inline else => switch ((&self.scalar).*) {
                inline else => |*scase| scase.call(T, data),
            },
        };
    }
};
