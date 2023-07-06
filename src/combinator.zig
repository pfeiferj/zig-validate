const std = @import("std");
const testing = std.testing;

pub fn And(comptime a: anytype, comptime b: anytype) type {
    return struct {
        const Self = @This();
        a: a,
        b: b,
        pub fn init() Self {
            return Self{
                .a = a.init(),
                .b = b.init(),
            };
        }

        pub fn validate(comptime self: @This(), comptime T: type, value: T) bool {
            return self.a.validate(T, value) and self.b.validate(T, value);
        }
    };
}

pub fn Or(comptime a: anytype, comptime b: anytype) type {
    return struct {
        const Self = @This();
        a: a,
        b: b,
        pub fn init() Self {
            return Self{
                .a = a.init(),
                .b = b.init(),
            };
        }

        pub fn validate(comptime self: @This(), comptime T: type, value: T) bool {
            return self.a.validate(T, value) or self.b.validate(T, value);
        }
    };
}

pub fn XOr(comptime a: anytype, comptime b: anytype) type {
    return struct {
        const Self = @This();
        a: a,
        b: b,
        pub fn init() Self {
            return Self{
                .a = a.init(),
                .b = b.init(),
            };
        }

        pub fn validate(comptime self: @This(), comptime T: type, value: T) bool {
            return self.a.validate(T, value) ^ self.b.validate(T, value);
        }
    };
}

pub fn Not(comptime a: anytype) type {
    return struct {
        const Self = @This();
        a: a,
        pub fn init() Self {
            return Self{
                .a = a.init(),
            };
        }

        pub fn validate(comptime self: @This(), comptime T: type, value: T) bool {
            return !self.a.validate(T, value);
        }
    };
}
