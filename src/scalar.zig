pub fn Max(comptime val: anytype) type {
    return struct {
        const Self = @This();
        val: @TypeOf(val),
        pub fn init() Self {
            return Self{
                .val = val,
            };
        }

        pub fn validate(comptime self: @This(), comptime T: type, value: T) bool {
            return self.val >= value;
        }
    };
}

pub fn Min(comptime val: anytype) type {
    return struct {
        const Self = @This();
        val: @TypeOf(val),
        pub fn init() Self {
            return Self{
                .val = val,
            };
        }

        pub fn validate(comptime self: @This(), comptime T: type, value: T) bool {
            return self.val <= value;
        }
    };
}

pub fn Equals(comptime val: anytype) type {
    return struct {
        const Self = @This();
        val: @TypeOf(val),
        pub fn init() Self {
            return Self{
                .val = val,
            };
        }

        pub fn validate(comptime self: @This(), comptime T: type, value: T) bool {
            return self.val == value;
        }
    };
}
