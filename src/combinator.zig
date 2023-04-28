const v = @import("./validator.zig");

pub const And = struct {
    validators: []*const v.Validator,

    pub fn call(self: @This(), comptime D: type, data: D) bool {
        var valid = true;
        for (self.validators) |validator| {
            valid = valid and validator.call(D, data);
        }
        return valid;
    }
};

pub fn _and(validators: anytype) v.Validator {
    const ml = v.Validator{ ._and = And{ .validators = validators } };
    return ml;
}

pub const Or = struct {
    validators: []*const v.Validator,

    pub fn call(self: @This(), comptime D: type, data: D) bool {
        var valid = true;
        for (self.validators) |validator| {
            valid = valid or validator.call(D, data);
        }
        return valid;
    }
};

pub fn _or(validators: anytype) v.Validator {
    const ml = v.Validator{ ._or = Or{ .validators = validators } };
    return ml;
}

pub const XOr = struct {
    validators: []*const v.Validator,

    pub fn call(self: @This(), comptime D: type, data: D) bool {
        var valid = false;
        for (self.validators) |validator| {
            if (valid) {
                valid = valid and !validator.call(D, data);
            } else {
                valid = valid or validator.call(D, data);
            }
        }
        return valid;
    }
};

pub fn _xor(validators: anytype) v.Validator {
    const ml = v.Validator{ ._xor = XOr{ .validators = validators } };
    return ml;
}

pub const Not = struct {
    validator: *const v.Validator,

    pub fn call(self: @This(), comptime D: type, data: D) bool {
        return !self.validator.call(D, data);
    }
};

pub fn _not(validator: anytype) v.Validator {
    const ml = v.Validator{ ._not = Not{ .validator = validator } };
    return ml;
}
