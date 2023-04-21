const v = @import("./validator.zig");

pub const Slice = union(enum) {
    min_length: MinLength,
    max_length: MaxLength,
};

pub fn max_length(m: u32) v.Validator {
    const ml = v.Validator{ .slice = .{ .max_length = MaxLength{ .max = m } } };
    return ml;
}

pub fn min_length(m: u32) v.Validator {
    const ml = v.Validator{ .slice = .{ .min_length = MinLength{ .min = m } } };
    return ml;
}

pub const MaxLength = struct {
    max: u32,
    pub fn call(self: @This(), comptime T: type, data: T) bool {
        return data.len <= self.max;
    }
};

pub const MinLength = struct {
    min: u32,
    pub fn call(self: @This(), comptime T: type, data: T) bool {
        return data.len >= self.min;
    }
};
