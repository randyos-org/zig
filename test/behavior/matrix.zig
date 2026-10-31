const std = @import("std");
const builtin = @import("builtin");
const expect = std.testing.expect;
const expectEqual = std.testing.expectEqual;

test "@Matrix type info" {
    const M = @Matrix(3, 2, f32);
    const info = @typeInfo(M).matrix;
    try expect(info.rows == 3);
    try expect(info.cols == 2);
    try expect(info.child == f32);
    try expect(std.mem.eql(u8, @typeName(M), "@Matrix(3, 2, f32)"));
}

test "@Matrix layout is an array of its columns" {
    inline for (.{ f16, f32, f64 }) |T| {
        inline for (2..5) |rows| {
            const M = @Matrix(rows, 4, T);
            try expect(@sizeOf(M) == 4 * @sizeOf(@Vector(rows, T)));
            try expect(@alignOf(M) == @alignOf(@Vector(rows, T)));
        }
    }
}

test "@Matrix is distinct from arrays of vectors" {
    try expect(@Matrix(2, 2, f32) != [2]@Vector(2, f32));
    try expect(@Matrix(2, 3, f32) != @Matrix(3, 2, f32));
    try expect(@Matrix(2, 2, f32) == @Matrix(2, 2, f32));
}

test "@Matrix coerces to and from arrays" {
    if (builtin.zig_backend == .stage2_arm) return error.SkipZigTest;
    if (builtin.zig_backend == .stage2_aarch64) return error.SkipZigTest;
    if (builtin.zig_backend == .stage2_riscv64) return error.SkipZigTest;
    if (builtin.zig_backend == .stage2_sparc64) return error.SkipZigTest;
    if (builtin.cpu.arch.isSpirv()) return error.SkipZigTest;

    const S = struct {
        fn doTheTest() !void {
            var array: [2][3]f32 = .{ .{ 1, 2, 3 }, .{ 4, 5, 6 } };
            _ = &array;
            const m: @Matrix(3, 2, f32) = array;
            const back: [2][3]f32 = m;
            try expectEqual(array, back);
        }
    };
    try S.doTheTest();
    try comptime S.doTheTest();
}

test "@Matrix coerces from a tuple of columns" {
    if (builtin.zig_backend == .stage2_arm) return error.SkipZigTest;
    if (builtin.zig_backend == .stage2_aarch64) return error.SkipZigTest;
    if (builtin.zig_backend == .stage2_riscv64) return error.SkipZigTest;
    if (builtin.zig_backend == .stage2_sparc64) return error.SkipZigTest;
    if (builtin.cpu.arch.isSpirv()) return error.SkipZigTest;

    const S = struct {
        fn doTheTest() !void {
            var x: f32 = 1;
            _ = &x;
            const columns = .{ [2]f32{ x, 0 }, [2]f32{ 0, x } };
            const m: @Matrix(2, 2, f32) = columns;
            const back: [2][2]f32 = m;
            try expectEqual([2][2]f32{ .{ 1, 0 }, .{ 0, 1 } }, back);
        }
    };
    try S.doTheTest();
    try comptime S.doTheTest();
}

test "@Matrix init syntax and indexing" {
    if (builtin.zig_backend == .stage2_arm) return error.SkipZigTest;
    if (builtin.zig_backend == .stage2_aarch64) return error.SkipZigTest;
    if (builtin.zig_backend == .stage2_riscv64) return error.SkipZigTest;
    if (builtin.zig_backend == .stage2_sparc64) return error.SkipZigTest;
    if (builtin.cpu.arch.isSpirv()) return error.SkipZigTest;

    const S = struct {
        fn doTheTest() !void {
            const M = @Matrix(3, 2, f32);
            var x: f32 = 1;
            _ = &x;
            var m: M = .{ .{ x, 2, 3 }, .{ 4, 5, 6 } };
            try expect(m.len == 2);
            try expectEqual(@Vector(3, f32){ 1, 2, 3 }, m[0]);
            try expectEqual(@Vector(3, f32){ 4, 5, 6 }, m[1]);
            try expect(m[1][2] == 6);

            var i: usize = 1;
            _ = &i;
            try expectEqual(@Vector(3, f32){ 4, 5, 6 }, m[i]);

            m[0] = .{ 7, 8, 9 };
            m[1][0] = 10;
            const back: [2][3]f32 = m;
            try expectEqual([2][3]f32{ .{ 7, 8, 9 }, .{ 10, 5, 6 } }, back);

            const typed = M{ m[1], m[0] };
            const c0, const c1 = typed;
            try expectEqual(m[1], c0);
            try expectEqual(m[0], c1);

            var sum: f32 = 0;
            for (typed) |column| sum += @reduce(.Add, column);
            try expect(sum == 45);
        }
    };
    try S.doTheTest();
    try comptime S.doTheTest();
}
