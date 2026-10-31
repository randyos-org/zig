const E = enum(u8) { a, b };

const storage_u8 = @extern(*addrspace(.storage_buffer) extern struct { val: u8 }, .{
    .name = "storage_u8",
    .decoration = .{ .descriptor = .{ .set = 0, .binding = 0 } },
});

const uniform_u8 = @extern(*addrspace(.uniform) extern struct { val: u8 }, .{
    .name = "uniform_u8",
    .decoration = .{ .descriptor = .{ .set = 0, .binding = 1 } },
});

const push_constant_u16 = @extern(*addrspace(.push_constant) extern struct { val: u16 }, .{
    .name = "push_constant_u16",
});

const storage_misc = @extern(*addrspace(.storage_buffer) extern struct { b: bool, e: E, h: f16 }, .{
    .name = "storage_misc",
    .decoration = .{ .descriptor = .{ .set = 0, .binding = 2 } },
});

export fn loadStorage() callconv(.kernel) void {
    _ = storage_u8.*;
}

export fn loadUniform() callconv(.kernel) void {
    _ = uniform_u8.*;
}

export fn loadPushConstant() callconv(.kernel) void {
    _ = push_constant_u16.*;
}

export fn loadBool() callconv(.kernel) void {
    _ = storage_misc.b;
}

export fn loadEnum() callconv(.kernel) void {
    _ = storage_misc.e;
}

export fn loadHalf() callconv(.kernel) void {
    _ = storage_misc.h;
}

// error
// backend=auto
// target=spirv32-vulkan
// cpu_features=baseline+int8+int16+int64+float16
//
// :23:19: error: cannot load or store 'u8' in address space 'storage_buffer' without feature 'storage_buffer8bit_access'
// :27:19: error: cannot load or store 'u8' in address space 'uniform' without feature 'uniform_and_storage_buffer8bit_access'
// :31:26: error: cannot load or store 'u16' in address space 'push_constant' without feature 'storage_push_constant16'
// :35:21: error: cannot load or store 'bool' in address space 'storage_buffer' without feature 'storage_buffer8bit_access'
// :39:21: error: cannot load or store 'tmp.E' in address space 'storage_buffer' without feature 'storage_buffer8bit_access'
// :43:21: error: cannot load or store 'f16' in address space 'storage_buffer' without feature 'storage_buffer16bit_access'
