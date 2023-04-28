const v = @import("./validator.zig");

fn isScalar(comptime data: type) bool {
    const t = @typeInfo(data);
    return t == .Int or t == .Float or t == .Bool or t == .Enum;
}
pub const Max = struct {
    max: Number,

    pub fn call(self: @This(), comptime D: type, data: D) bool {
        if (!comptime isScalar(D)) return false;
        return data <= self.max.get(D);
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

    pub fn get(self: *const Number, comptime T: type) T {
        return switch (T) {
            inline i8 => self.i8,
            inline u8 => self.u8,
            inline i16 => self.i16,
            inline u16 => self.u16,
            inline i32 => self.i32,
            inline u32 => self.u32,
            inline i64 => self.i64,
            inline u64 => self.u64,
            inline i128 => self.i128,
            inline u128 => self.u128,
            inline isize => self.isize,
            inline usize => self.usize,
            inline c_short => self.c_short,
            inline c_ushort => self.c_ushort,
            inline c_int => self.c_int,
            inline c_uint => self.c_uint,
            inline c_long => self.c_long,
            inline c_ulong => self.c_ulong,
            inline c_longlong => self.c_longlong,
            inline c_ulonglong => self.c_ulonglong,
            inline c_longdouble => self.c_longdouble,
            inline f16 => self.f16,
            inline f32 => self.f32,
            inline f64 => self.f64,
            inline f80 => self.f80,
            inline f128 => self.f128,
            else => unreachable,
        };
    }
};

pub fn number(n: anytype) Number {
    comptime var T = @TypeOf(n);
    if (T == comptime_int or T == comptime_float) return Number{ .f128 = @as(f128, n) };

    return switch (T) {
        inline i8 => Number{ .i8 = n },
        inline u8 => Number{ .u8 = n },
        inline i16 => Number{ .i16 = n },
        inline u16 => Number{ .u16 = n },
        inline i32 => Number{ .i32 = n },
        inline u32 => Number{ .u32 = n },
        inline i64 => Number{ .i64 = n },
        inline u64 => Number{ .u64 = n },
        inline i128 => Number{ .i128 = n },
        inline u128 => Number{ .u128 = n },
        inline isize => Number{ .isize = n },
        inline usize => Number{ .usize = n },
        inline c_short => Number{ .c_short = n },
        inline c_ushort => Number{ .c_ushort = n },
        inline c_int => Number{ .c_int = n },
        inline c_uint => Number{ .c_uint = n },
        inline c_long => Number{ .c_long = n },
        inline c_ulong => Number{ .c_ulong = n },
        inline c_longlong => Number{ .c_longlong = n },
        inline c_ulonglong => Number{ .c_ulonglong = n },
        inline c_longdouble => Number{ .c_longdouble = n },
        inline f16 => Number{ .f16 = n },
        inline f32 => Number{ .f32 = n },
        inline f64 => Number{ .f64 = n },
        inline f80 => Number{ .f80 = n },
        inline f128 => Number{ .f128 = n },
        else => unreachable,
    };
}

pub const Min = struct {
    min: Number,

    pub fn call(self: @This(), comptime D: type, data: D) bool {
        if (!comptime isScalar(D)) return false;
        return data >= self.min.get(D);
    }
};

pub fn max(comptime m: anytype) v.Validator {
    const ml = v.Validator{ .max = Max{
        .max = number(m),
    } };
    return ml;
}

pub fn min(comptime m: anytype) v.Validator {
    const ml = v.Validator{ .min = Min{
        .min = number(m),
    } };
    return ml;
}
