export fn a() void {
    _ = @Matrix(0, 2, f32);
}
export fn b() void {
    _ = @Matrix(2, 0, f32);
}
export fn c() void {
    _ = @Matrix(2, 2, u32);
}

// error
//
// :2:17: error: matrix must have at least one row
// :5:20: error: matrix must have at least one column
// :8:23: error: expected float for the matrix element type; found 'u32'
