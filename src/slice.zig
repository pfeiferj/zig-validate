const v = @import("./validator.zig");

fn isSlice(comptime data: type) bool {
    const t = @typeInfo(data);
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
    pub fn call(self: @This(), comptime D: type, data: D) bool {
        if (!comptime isSlice(D)) return false;

        return data.len <= self.max;
    }
};

pub const MinLength = struct {
    min: u32,
    pub fn call(self: @This(), comptime D: type, data: D) bool {
        if (!comptime isSlice(D)) return false;
        return data.len >= self.min;
    }
};

pub fn equals(d: anytype) v.Validator {
    const e = v.Validator{ .slice_equals = Equals{ .match = @ptrCast([*]u8, @constCast(d)), .length = d.len, .alignment = @alignOf(@TypeOf(d)) } };
    return e;
}

pub const Equals = struct {
    match: [*]u8,
    length: usize,
    alignment: usize,

    pub fn call(self: @This(), comptime D: type, data: D) bool {
        if (!comptime isSlice(D)) return false;
        const m = @ptrCast([*]@TypeOf(data[0]), @alignCast(@alignOf(@TypeOf(data)), self.match));

        if (self.length != data.len) return false;

        var i: u32 = 0;

        while (i < data.len) : (i += 1) {
            if (data[i] != m[i]) return false;
        }

        return true;
    }
};
