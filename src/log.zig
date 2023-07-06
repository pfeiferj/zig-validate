pub fn Failure(comptime v: anytype, comptime logger: anytype, message: []const u8) type {
    return struct {
        const Self = @This();
        v: v,
        logger: @TypeOf(logger),
        message: []const u8,
        pub fn init() Self {
            return Self{
                .v = v.init(),
                .logger = logger,
                .message = message,
            };
        }

        pub fn validate(comptime self: @This(), comptime T: type, value: T) bool {
            if (!self.v.validate(T, value)) {
                self.logger(self.message, .{});

                return false;
            }
            return true;
        }
    };
}

pub fn Success(comptime v: anytype, comptime logger: anytype, message: []const u8) type {
    return struct {
        const Self = @This();
        v: v,
        logger: @TypeOf(logger),
        message: []const u8,
        pub fn init() Self {
            return Self{
                .v = v.init(),
                .logger = logger,
                .message = message,
            };
        }

        pub fn validate(comptime self: @This(), comptime T: type, value: T) bool {
            if (self.v.validate(T, value)) {
                self.logger(self.message, .{});

                return true;
            }
            return false;
        }
    };
}
