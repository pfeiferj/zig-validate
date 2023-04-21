const v = @import("./validator.zig");

pub const Scalar = union(enum) {
    min: Min,
    max: Max,
};

pub const Max = struct {
    max: u32,
    pub fn call(self: @This(), comptime T: type, data: T) bool {
        return data <= self.max;
    }
};

pub const Min = struct {
    min: u32,
    pub fn call(self: @This(), comptime T: type, data: T) bool {
        return data >= self.min;
    }
};

pub fn max(m: u32) v.Validator {
    const ml = v.Validator{ .scalar = .{ .max = Max{ .max = m } } };
    return ml;
}

pub fn min(m: u32) v.Validator {
    const ml = v.Validator{ .scalar = .{ .min = Min{ .min = m } } };
    return ml;
}
