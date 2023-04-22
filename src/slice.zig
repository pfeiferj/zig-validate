const v = @import("./validator.zig");

fn isSlice(data: anytype) bool {
    const t = @typeInfo(@TypeOf(data));
    return t == .Pointer;
}

pub fn max_length(m: u32) v.Validator {
    const ml = v.Validator{ .max_length = MaxLength{ .max = m } };
    return ml;
}

pub fn min_length(m: u32) v.Validator {
    const ml = v.Validator{ .min_length = MinLength{ .min = m } };
    return ml;
}

pub const MaxLength = struct {
    max: u32,
    pub fn call(self: @This(), comptime data: anytype) bool {
        if (!comptime isSlice(data)) return false;

        return data.len <= self.max;
    }
};

pub const MinLength = struct {
    min: u32,
    pub fn call(self: @This(), comptime data: anytype) bool {
        if (!comptime isSlice(data)) return false;
        return data.len >= self.min;
    }
};
