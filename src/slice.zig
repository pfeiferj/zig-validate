const regex = @import("regex");

pub fn MaxLength(comptime val: anytype) type {
    return struct {
        const Self = @This();
        val: @TypeOf(val),
        pub fn init() Self {
            return Self{
                .val = val,
            };
        }

        pub fn validate(comptime self: @This(), comptime T: type, value: T) bool {
            if (self.val < value.len) {
                return false;
            }

            return true;
        }
    };
}

pub fn MinLength(comptime val: anytype) type {
    return struct {
        const Self = @This();
        val: @TypeOf(val),
        pub fn init() Self {
            return Self{
                .val = val,
            };
        }

        pub fn validate(comptime self: @This(), comptime T: type, value: T) bool {
            if (self.val > value.len) {
                return false;
            }

            return true;
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
            if (self.val.len != value.len) {
                return false;
            }

            var i: u32 = 0;

            while (i < self.val.len) : (i += 1) {
                if (self.val[i] != value[i]) return false;
            }

            return true;
        }
    };
}

pub fn BeginsWith(comptime val: anytype) type {
    return struct {
        const Self = @This();
        val: @TypeOf(val),
        pub fn init() Self {
            return Self{
                .val = val,
            };
        }

        pub fn validate(comptime self: @This(), comptime T: type, value: T) bool {
            if (value.len < self.val.len) {
                return false;
            }

            var i: usize = 0;

            while (i < self.val.len) : (i += 1) {
                if (self.val[i] != value[i]) return false;
            }

            return true;
        }
    };
}

pub fn EndsWith(comptime val: anytype) type {
    return struct {
        const Self = @This();
        val: @TypeOf(val),
        pub fn init() Self {
            return Self{
                .val = val,
            };
        }

        pub fn validate(comptime self: @This(), comptime T: type, value: T) bool {
            if (value.len < self.val.len) {
                return false;
            }

            var i: usize = value.len;

            while (i > 0) : (i -= 1) {
                if (self.val[i] != value[i]) return false;
            }

            return true;
        }
    };
}

pub fn RegexMatch(comptime val: []const u8) type {
    const rex = regex.compile(val);
    return struct {
        const Self = @This();
        rex: rex,
        pub fn init() Self {
            return Self{
                .rex = rex.init(),
            };
        }

        pub fn validate(comptime self: @This(), comptime T: type, value: T) bool {
            return self.rex.matches(value);
        }
    };
}
