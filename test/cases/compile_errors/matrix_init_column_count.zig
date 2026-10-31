export fn entry() void {
    const m = @Matrix(2, 2, f32){ .{ 1, 0 }, .{ 0, 1 }, .{ 0, 0 } };
    _ = m;
}

// error
//
// :2:33: error: expected 2 matrix columns; found 3
