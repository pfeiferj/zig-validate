pub fn Failure(comptime T: type, comptime T2: type) type {
    return comptime struct {
        validator: T,
        logger: T2,
        message: []const u8,
        pub fn call(comptime self: @This(), data: anytype) bool {
            if (!self.validator.call(data)) {
                self.logger(self.message, .{});

                return false;
            }
            return true;
        }
    };
}

// log a custom message when validation fails
pub fn failure(comptime v: anytype, comptime logger: anytype, message: []const u8) Failure(@TypeOf(v), @TypeOf(logger)) {
    return comptime .{ .validator = v, .logger = logger, .message = message };
}

pub fn Success(comptime T: type, comptime T2: type) type {
    return comptime struct {
        validator: T,
        logger: T2,
        message: []const u8,
        pub fn call(comptime self: @This(), data: anytype) bool {
            if (self.validator.call(data)) {
                self.logger(self.message, .{});
                return true;
            }
            return false;
        }
    };
}

// log a custom message when validation succeeds
pub fn success(comptime v: anytype, comptime logger: anytype, message: []const u8) Success(@TypeOf(v), @TypeOf(logger)) {
    return comptime .{ .validator = v, .logger = logger, .message = message };
}
