export fn badShapes() void {
    const a: @Matrix(2, 3, f32) = .{ .{ 1, 2 }, .{ 3, 4 }, .{ 5, 6 } };
    _ = a * a;
}
export fn badVector() void {
    const a: @Matrix(2, 3, f32) = .{ .{ 1, 2 }, .{ 3, 4 }, .{ 5, 6 } };
    _ = a * @Vector(2, f32){ 1, 2 };
}
export fn badOperator() void {
    const a: @Matrix(2, 2, f32) = .{ .{ 1, 2 }, .{ 3, 4 } };
    _ = a / a;
}
export fn badCompare() void {
    const a: @Matrix(2, 2, f32) = .{ .{ 1, 2 }, .{ 3, 4 } };
    _ = a == a;
}

// error
//
// :3:11: error: cannot multiply '@Matrix(2, 3, f32)' by '@Matrix(2, 3, f32)'
// :7:11: error: cannot multiply '@Matrix(2, 3, f32)' by '@Vector(2, f32)'
// :11:11: error: matrices support only the '+', '-' and '*' operators
// :15:11: error: matrices support only the '+', '-' and '*' operators
