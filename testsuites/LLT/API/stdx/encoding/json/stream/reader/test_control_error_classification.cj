// Copyright (c) Huawei Technologies Co., Ltd. 2026. All rights reserved.
// This source file is part of the Cangjie project, licensed under Apache-2.0
// with Runtime Library Exception.
//
// See https://cangjie-lang.cn/pages/LICENSE for license information.

// LEVEL: 0
// EXEC: %compiler %import-cangjie-stdx %cmp_opt -O2 %f -o %output
// EXEC: %set_stdx_path %run %run_opt %output %run_args

import std.io.*
import stdx.encoding.json.stream.*

func expectError(bytes: Array<Byte>, expected: String): Unit {
    let buffer = ByteBuffer()
    buffer.write(bytes)
    let reader = JsonReader(buffer)
    var rejected = false
    try { let _ = reader.readValue<String>() }
    catch (error: IllegalStateException) {
        rejected = true
        if (error.message != expected) {
            throw Exception("Expected '${expected}', got '${error.message}'")
        }
    }
    if (!rejected) { throw Exception("Invalid JSON string was accepted") }
}

main(): Int64 {
    for (code in 0..32) {
        expectError([b'"', UInt8(code), b'"'], "Unescaped control character in JSON string.")
        expectError([b'"', b'\\', b'n', UInt8(code), b'"'],
            "Unescaped control character in JSON string.")
    }
    expectError([b'"', 0xC0, 0xAF, b'"'], "Invalid UTF-8 byte sequence.")
    let buffer = ByteBuffer()
    buffer.write([b'"', b'\\', b'u', b'0', b'0', b'0', b'1', b'"'])
    let value = JsonReader(buffer).readValue<String>()
    let bytes = value.toArray()
    if (bytes.size != 1 || bytes[0] != 1u8) { throw Exception("Escaped control must remain valid") }
    println("JSON string error classification passed")
    0
}
