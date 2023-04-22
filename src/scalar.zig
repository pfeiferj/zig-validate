const v = @import("./validator.zig");

fn isScalar(data: anytype) bool {
    const t = @typeInfo(@TypeOf(data));
    return t == .Int or t == .Float or t == .Bool or t == .Enum;
}
pub const Max = struct {
    max: u32,
    pub fn call(self: @This(), comptime data: anytype) bool {
        if (!comptime isScalar(data)) return false;
        return data <= self.max;
    }
};

pub const Min = struct {
    min: u32,
    pub fn call(self: @This(), comptime data: anytype) bool {
        if (!comptime isScalar(data)) return false;
        return data >= self.min;
    }
};

pub fn max(m: u32) v.Validator {
    const ml = v.Validator{ .max = Max{ .max = m } };
    return ml;
}

pub fn min(m: u32) v.Validator {
    const ml = v.Validator{ .min = Min{ .min = m } };
    return ml;
}
