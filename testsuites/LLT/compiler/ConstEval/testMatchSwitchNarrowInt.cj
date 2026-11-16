// Copyright (c) Huawei Technologies Co., Ltd. 2025. All rights reserved.
// This source file is part of the Cangjie project, licensed under Apache-2.0
// with Runtime Library Exception.
//
// See https://cangjie-lang.cn/pages/LICENSE for license information.

// EXEC: %compiler %compile_exe_opt %n.cj -o %output 2>&1 | compare %f
// EXEC: %run %run_opt %output %run_args
// ASSERT: scan-not core dumped
// ASSERT: scan-not stack trace

// Tests constant evaluation of match expressions lowered to a switch on integer types narrower
// than 64 bits, including negative values and values that do not fit in 8 bits.

const func matchInt8(x: Int8): Int64 {
    match (x) {
        case -128 | 127 => 1
        case -1 | 1 => 2
        case _ => 0
    }
}

const func matchInt16(x: Int16): Int64 {
    match (x) {
        case -32768 | 300 => 1
        case -1 | 44 => 2
        case _ => 0
    }
}

const func matchInt32(x: Int32): Int64 {
    match (x) {
        case -2147483648 | 65536 => 1
        case -1 | 2147483647 => 2
        case _ => 0
    }
}

const func matchUInt8(x: UInt8): Int64 {
    match (x) {
        case 255 | 0 => 1
        case 128 | 1 => 2
        case _ => 0
    }
}

const func matchUInt16(x: UInt16): Int64 {
    match (x) {
        case 65535 | 256 => 1
        case 300 | 0 => 2
        case _ => 0
    }
}

const func matchUInt32(x: UInt32): Int64 {
    match (x) {
        case 4294967295 | 256 => 1
        case 65536 | 0 => 2
        case _ => 0
    }
}

const func matchIntNative(x: IntNative): Int64 {
    match (x) {
        case -1 | 300 => 1
        case 44 | 4294967296 => 2
        case _ => 0
    }
}

const func matchUIntNative(x: UIntNative): Int64 {
    match (x) {
        case 18446744073709551615 | 300 => 1
        case 44 | 4294967296 => 2
        case _ => 0
    }
}

const I8_MIN = matchInt8(-128)
const I8_M1 = matchInt8(-1)
const I16_MIN = matchInt16(-32768)
const I16_300 = matchInt16(300)
const I16_M1 = matchInt16(-1)
const I32_MIN = matchInt32(-2147483648)
const I32_65536 = matchInt32(65536)
const I32_M1 = matchInt32(-1)
const U8_255 = matchUInt8(255)
const U8_128 = matchUInt8(128)
const U16_MAX = matchUInt16(65535)
const U16_300 = matchUInt16(300)
const U16_44 = matchUInt16(44)
const U32_MAX = matchUInt32(4294967295)
const U32_65536 = matchUInt32(65536)
const INAT_M1 = matchIntNative(-1)
const INAT_300 = matchIntNative(300)
const INAT_BIG = matchIntNative(4294967296)
const UNAT_MAX = matchUIntNative(18446744073709551615)
const UNAT_BIG = matchUIntNative(4294967296)

func check(name: String, c: Int64, r: Int64, expected: Int64): Int64 {
    if (c == expected && r == expected) {
        return 0
    }
    println("${name}: const=${c} runtime=${r} expected=${expected}")
    return 1
}

main(): Int64 {
    var failures = 0
    failures += check("I8_MIN", I8_MIN, matchInt8(-128), 1)
    failures += check("I8_M1", I8_M1, matchInt8(-1), 2)
    failures += check("I16_MIN", I16_MIN, matchInt16(-32768), 1)
    failures += check("I16_300", I16_300, matchInt16(300), 1)
    failures += check("I16_M1", I16_M1, matchInt16(-1), 2)
    failures += check("I32_MIN", I32_MIN, matchInt32(-2147483648), 1)
    failures += check("I32_65536", I32_65536, matchInt32(65536), 1)
    failures += check("I32_M1", I32_M1, matchInt32(-1), 2)
    failures += check("U8_255", U8_255, matchUInt8(255), 1)
    failures += check("U8_128", U8_128, matchUInt8(128), 2)
    failures += check("U16_MAX", U16_MAX, matchUInt16(65535), 1)
    failures += check("U16_300", U16_300, matchUInt16(300), 2)
    failures += check("U16_44", U16_44, matchUInt16(44), 0)
    failures += check("U32_MAX", U32_MAX, matchUInt32(4294967295), 1)
    failures += check("U32_65536", U32_65536, matchUInt32(65536), 2)
    failures += check("INAT_M1", INAT_M1, matchIntNative(-1), 1)
    failures += check("INAT_300", INAT_300, matchIntNative(300), 1)
    failures += check("INAT_BIG", INAT_BIG, matchIntNative(4294967296), 2)
    failures += check("UNAT_MAX", UNAT_MAX, matchUIntNative(18446744073709551615), 1)
    failures += check("UNAT_BIG", UNAT_BIG, matchUIntNative(4294967296), 2)
    return failures
}
