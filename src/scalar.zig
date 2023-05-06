pub fn Max(comptime T: type) type {
    return comptime struct {
        value: T,
        pub fn call(comptime self: @This(), data: anytype) bool {
            return data <= self.value;
        }
    };
}

pub fn max(comptime val: anytype) Max(@TypeOf(val)) {
    return comptime .{ .value = val };
}

pub fn Min(comptime T: type) type {
    return comptime struct {
        value: T,
        pub fn call(comptime self: @This(), data: anytype) bool {
            return data >= self.value;
        }
    };
}

pub fn min(comptime val: anytype) Min(@TypeOf(val)) {
    return comptime .{ .value = val };
}

pub fn Equals(comptime T: type) type {
    return comptime struct {
        value: T,
        pub fn call(comptime self: @This(), data: anytype) bool {
            return data == self.value;
        }
    };
}

pub fn equals(comptime val: anytype) Equals(@TypeOf(val)) {
    return comptime .{ .value = val };
}
