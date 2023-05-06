const std = @import("std");
const testing = std.testing;

pub fn And(comptime T: type) type {
    return comptime struct {
        validators: T,

        pub fn call(comptime self: @This(), data: anytype) bool {
            inline for (self.validators) |validator| {
                if (!validator.call(data)) {
                    return false;
                }
            }
            return true;
        }
    };
}

pub fn _and(comptime validators: anytype) And(@TypeOf(validators)) {
    return comptime .{ .validators = validators };
}

pub fn Or(comptime T: type) type {
    return comptime struct {
        validators: T,

        pub fn call(comptime self: @This(), data: anytype) bool {
            inline for (self.validators) |validator| {
                if (validator.call(data)) {
                    return true;
                }
            }
            return false;
        }
    };
}

pub fn _or(comptime validators: anytype) Or(@TypeOf(validators)) {
    return comptime .{ .validators = validators };
}

pub fn XOr(comptime T: type) type {
    return comptime struct {
        validators: T,

        pub fn call(comptime self: @This(), data: anytype) bool {
            var valid = false;
            inline for (self.validators) |validator| {
                if (valid) {
                    if (validator.call(data)) {
                        return false;
                    }
                } else {
                    valid = validator.call(data);
                }
            }
            return valid;
        }
    };
}

pub fn _xor(comptime validators: anytype) XOr(@TypeOf(validators)) {
    return comptime .{ .validators = validators };
}

pub fn Not(comptime T: type) type {
    return comptime struct {
        validator: T,

        pub fn call(comptime self: @This(), data: anytype) bool {
            return !self.validator.call(data);
        }
    };
}

pub fn _not(comptime validators: anytype) Not(@TypeOf(validators)) {
    return comptime .{ .validators = validators };
}
