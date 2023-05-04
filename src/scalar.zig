const v = @import("./validator.zig");

fn isScalar(comptime data: type) bool {
    const t = @typeInfo(data);
    return t == .Int or t == .Float or t == .Bool or t == .Enum;
}
pub const Max = struct {
    max: Number,

    pub fn call(self: @This(), comptime D: type, data: D) bool {
        if (!comptime isScalar(D)) return false;
        return data <= @field(self.max, @typeName(D));
    }
};

pub const Number = union(enum) {
    i8: i8,
    u8: u8,
    i16: i16,
    u16: u16,
    i32: i32,
    u32: u32,
    i64: i64,
    u64: u64,
    i128: i128,
    u128: u128,
    isize: isize,
    usize: usize,
    c_short: c_short,
    c_ushort: c_ushort,
    c_int: c_int,
    c_uint: c_uint,
    c_long: c_long,
    c_ulong: c_ulong,
    c_longlong: c_longlong,
    c_ulonglong: c_ulonglong,
    c_longdouble: c_longdouble,
    f16: f16,
    f32: f32,
    f64: f64,
    f80: f80,
    f128: f128,
};

pub fn number(n: anytype) Number {
    comptime var T = @TypeOf(n);
    if (T == comptime_int or T == comptime_float) return Number{ .f128 = @as(f128, n) };
    return @unionInit(Number, @typeName(T), n);
}

pub const Min = struct {
    min: Number,

    pub fn call(self: @This(), comptime D: type, data: D) bool {
        if (!comptime isScalar(D)) return false;
        return data >= @field(self.min, @typeName(D));
    }
};

pub const Equals = struct {
    value: Number,

    pub fn call(self: @This(), comptime D: type, data: D) bool {
        if (!comptime isScalar(D)) return false;
        return data == @field(self.value, @typeName(D));
    }
};

pub fn max(comptime T: type, m: T) v.Validator {
    const ml = v.Validator{ .max = Max{
        .max = number(m),
    } };
    return ml;
}

pub fn min(comptime T: type, m: T) v.Validator {
    const ml = v.Validator{ .min = Min{
        .min = number(m),
    } };
    return ml;
}

pub fn equals(comptime T: type, val: T) v.Validator {
    const e = v.Validator{ .scalar_equals = Equals{
        .value = number(val),
    } };
    return e;
}
