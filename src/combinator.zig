const v = @import("./validator.zig");

pub const And = struct {
    validators: []*const v.Validator,

    pub fn call(self: @This(), comptime data: anytype) bool {
        var valid = true;
        for (self.validators) |validator| {
            valid = valid and validator.call(data);
        }
        return valid;
    }
};

pub fn _and(validators: anytype) v.Validator {
    const ml = v.Validator{ ._and = And{ .validators = validators } };
    return ml;
}
