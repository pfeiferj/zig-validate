const re = @cImport(@cInclude("re.h"));

pub fn MaxLength(comptime T: type) type {
    return comptime struct {
        value: T,
        pub fn call(comptime self: @This(), data: anytype) bool {
            return data.len <= self.value;
        }
    };
}

pub fn max_length(max: anytype) MaxLength(@TypeOf(max)) {
    return comptime .{ .value = max };
}

pub fn MinLength(comptime T: type) type {
    return comptime struct {
        value: T,
        pub fn call(comptime self: @This(), data: anytype) bool {
            return data.len >= self.value;
        }
    };
}

pub fn min_length(min: anytype) MinLength(@TypeOf(min)) {
    return comptime .{ .value = min };
}

pub fn Equals(comptime T: type) type {
    return comptime struct {
        value: T,
        pub fn call(comptime self: @This(), val: anytype) bool {
            if (self.value.len != val.len) {
                return false;
            }

            var i: u32 = 0;

            while (i < self.value.len) : (i += 1) {
                if (self.value[i] != val[i]) return false;
            }

            return true;
        }
    };
}

pub fn equals(comptime val: anytype) Equals(@TypeOf(val)) {
    return comptime .{ .value = val };
}

pub fn BeginsWith(comptime T: type) type {
    return comptime struct {
        value: T,
        pub fn call(comptime self: @This(), val: anytype) bool {
            if (val.len < self.value.len) {
                return false;
            }

            var i: u32 = 0;

            while (i < self.value.len) : (i += 1) {
                if (self.value[i] != val[i]) return false;
            }

            return true;
        }
    };
}

pub fn begins_with(comptime val: anytype) BeginsWith(@TypeOf(val)) {
    return comptime .{ .value = val };
}

pub fn EndsWith(comptime T: type) type {
    return comptime struct {
        value: T,
        pub fn call(comptime self: @This(), val: anytype) bool {
            if (val.len < self.value.len) {
                return false;
            }

            var i: u32 = 0;

            while (i < self.value.len) : (i += 1) {
                if (self.value[i] != val[val.len - i - 1]) return false;
            }

            return true;
        }
    };
}

pub fn ends_with(comptime val: anytype) BeginsWith(@TypeOf(val)) {
    return comptime .{ .value = val };
}

pub fn RegexMatch(comptime T: type) type {
    return comptime struct {
        value: T,
        pub fn call(comptime self: @This(), val: anytype) bool {
            var c_data = @ptrCast([:0]const u8, val);

            var match_length: c_int = 0;
            var match_idx: isize = re.re_match(self.value, c_data, &match_length);

            return match_idx != -1;
        }
    };
}

pub fn regex_match(comptime expression: anytype) RegexMatch(@TypeOf(expression)) {
    return comptime .{ .value = expression };
}
