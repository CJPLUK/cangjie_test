/*
 * Copyright (c) Huawei Technologies Co., Ltd. 2026. All rights reserved.
 * This source file is part of the Cangjie project, licensed under Apache-2.0
 * with Runtime Library Exception.
 *
 * See https://cangjie-lang.cn/pages/LICENSE for license information.
 */
// LEVEL: 0
// DEPENDENCE: ./local_mode_utils.cj
// EXEC: %compiler %local %cmp_opt ./local_mode_utils.cj %f -o %output
// EXEC: %run %run_opt %output %run_args
//
// 覆盖 `comparable.cj` 为每个原始类型新增的 local 比较面。
//
// 该文件为 13 个原始类型（IntNative/Int64/Int32/Int16/Int8、UIntNative/UInt64/
// UInt32/UInt16/UInt8、Float64/Float32/Float16）各自新增了
// `compare(this @local?, other: T @local?)` 与 6 个比较运算符的 `@local?`
// 形态，外加 26 个 `@local!` 专用 ==/!= 重载；`Ordering` 自身还新增了 local
// 比较与 toString。此前的用例只覆盖 Int64，其余类型从未执行。
//
// 判定掩码（与用例内 helper 一致）：
//   LT=1 EQ=2 GT=4（来自 compare 的三路 match）
//   ==:+8  !=:+16  <:+32  >:+64  <=:+128  >=:+256
// 每个关系都断言精确值，使 compare 的 match 各分支与 6 个运算符的两侧分支
// 都被执行。

import std.core.*

// 单个关系的期望掩码；LT=177、EQ=394、GT=340。
func maskOf(relation: Ordering): Int64 {
    match (relation) {
        case Ordering.LT => 177
        case Ordering.EQ => 394
        case Ordering.GT => 340
    }
}

// 用泛型覆盖全部 Comparable<T> 原始类型：local 形态经接口分派到具体实现。
func minSpaceOps<T>(a: T @local!, b: T @local!): Int64 where T <: Comparable<T> {
    let x: T @local? = a
    let y: T @local? = b
    var r: Int64 = 0
    match (x.compare(y)) {
        case Ordering.LT => r += 1
        case Ordering.EQ => r += 2
        case Ordering.GT => r += 4
    }
    if (x == y) { r += 8 }
    if (x != y) { r += 16 }
    if (x < y) { r += 32 }
    if (x > y) { r += 64 }
    if (x <= y) { r += 128 }
    if (x >= y) { r += 256 }
    r
}

// @local! 接收/实参形态（26 个专用重载）。@local! 实参必须在 exclave 上下文中
// 传给 @local! 形参，因此这两个 probe 用 exclave 包裹。
func fullSpaceEq<T>(a: T @local!, b: T @local!): Bool where T <: Comparable<T> {
    exclave { a == b }
}

func fullSpaceNe<T>(a: T @local!, b: T @local!): Bool where T <: Comparable<T> {
    exclave { a != b }
}

// Ordering 自身的 local 比较面。
func orderingOps(a: Ordering @local!, b: Ordering @local!): Int64 {
    let x: Ordering @local? = a
    let y: Ordering @local? = b
    var r: Int64 = 0
    match (x.compare(y)) {
        case Ordering.LT => r += 1
        case Ordering.EQ => r += 2
        case Ordering.GT => r += 4
    }
    if (x == y) { r += 8 }
    if (x != y) { r += 16 }
    if (x < y) { r += 32 }
    if (x > y) { r += 64 }
    if (x <= y) { r += 128 }
    if (x >= y) { r += 256 }
    r
}

// Ordering.toString(@local?) 返回 String @local!，三个分支各断言一次。
func orderingToStringIs(value: Ordering @local!, want: String @local!): Bool {
    exclave {
        let half: Ordering @local? = value
        let text: String @local! = half.toString()
        text == want
    }
}

main(): Int64 {
    var failed = 0

    // ---- 有符号整数：LT / EQ / GT 三种关系 × 10 个类型 ----

    let i64lo: Int64 @local! = -9223372036854775808
    let i64hi: Int64 @local! = 9223372036854775807
    failed += assertEq(minSpaceOps<Int64>(i64lo, i64hi), maskOf(Ordering.LT), "P_Int64_lt")
    failed += assertEq(minSpaceOps<Int64>(i64hi, i64lo), maskOf(Ordering.GT), "P_Int64_gt")
    failed += assertEq(minSpaceOps<Int64>(i64hi, i64hi), maskOf(Ordering.EQ), "P_Int64_eq")
    failed += assertB(fullSpaceEq<Int64>(i64hi, i64hi), "P_Int64_bang_eq")
    failed += assertB(fullSpaceNe<Int64>(i64lo, i64hi), "P_Int64_bang_ne")

    let int64_0: Int64 @local! = 0
    let int64_1: Int64 @local! = 1
    failed += assertEq(minSpaceOps<Int64>(int64_0, int64_1), maskOf(Ordering.LT), "P_Int64_zero_lt")
    failed += assertEq(minSpaceOps<Int64>(int64_0, int64_0), maskOf(Ordering.EQ), "P_Int64_zero_eq")

    let inLo: IntNative @local! = -128
    let inHi: IntNative @local! = 127
    failed += assertEq(minSpaceOps<IntNative>(inLo, inHi), maskOf(Ordering.LT), "P_IntNative_lt")
    failed += assertEq(minSpaceOps<IntNative>(inHi, inLo), maskOf(Ordering.GT), "P_IntNative_gt")
    failed += assertEq(minSpaceOps<IntNative>(inLo, inLo), maskOf(Ordering.EQ), "P_IntNative_eq")

    let i32lo: Int32 @local! = -2147483648
    let i32hi: Int32 @local! = 2147483647
    failed += assertEq(minSpaceOps<Int32>(i32lo, i32hi), maskOf(Ordering.LT), "P_Int32_lt")
    failed += assertEq(minSpaceOps<Int32>(i32hi, i32lo), maskOf(Ordering.GT), "P_Int32_gt")
    failed += assertEq(minSpaceOps<Int32>(i32hi, i32hi), maskOf(Ordering.EQ), "P_Int32_eq")

    let i16lo: Int16 @local! = -32768
    let i16hi: Int16 @local! = 32767
    failed += assertEq(minSpaceOps<Int16>(i16lo, i16hi), maskOf(Ordering.LT), "P_Int16_lt")
    failed += assertEq(minSpaceOps<Int16>(i16hi, i16lo), maskOf(Ordering.GT), "P_Int16_gt")
    failed += assertEq(minSpaceOps<Int16>(i16lo, i16hi - 1), maskOf(Ordering.LT), "P_Int16_lt2")

    let i8lo: Int8 @local! = -128
    let i8hi: Int8 @local! = 127
    failed += assertEq(minSpaceOps<Int8>(i8lo, i8hi), maskOf(Ordering.LT), "P_Int8_lt")
    failed += assertEq(minSpaceOps<Int8>(i8hi, i8lo), maskOf(Ordering.GT), "P_Int8_gt")
    failed += assertEq(minSpaceOps<Int8>(i8lo, i8lo), maskOf(Ordering.EQ), "P_Int8_eq")
    failed += assertB(fullSpaceEq<Int8>(i8hi, i8hi), "P_Int8_bang_eq")
    failed += assertB(fullSpaceNe<Int8>(i8lo, i8hi), "P_Int8_bang_ne")
    failed += assertB(!fullSpaceEq<Int8>(i8lo, i8hi), "P_Int8_bang_eq_false")

    // ---- 补齐每个类型的 @local! 专用 ==/!= 重载（共 26 个）----
    // 这些是 `==(this @local!, other: T @local!)` 形态，与 @local? 版本是不同重载；
    // 只调 @local? 形态不会覆盖它们。
    failed += assertB(fullSpaceEq<IntNative>(inLo, inLo), "P_IntNative_bang_eq")
    failed += assertB(fullSpaceNe<IntNative>(inLo, inHi), "P_IntNative_bang_ne")
    failed += assertB(fullSpaceEq<Int32>(i32hi, i32hi), "P_Int32_bang_eq")
    failed += assertB(fullSpaceNe<Int32>(i32lo, i32hi), "P_Int32_bang_ne")
    failed += assertB(fullSpaceEq<Int16>(i16hi, i16hi), "P_Int16_bang_eq")
    failed += assertB(fullSpaceNe<Int16>(i16lo, i16hi), "P_Int16_bang_ne")

    // ---- 无符号整数 ----

    let unHi: UIntNative @local! = 255
    let unLo: UIntNative @local! = 0
    failed += assertEq(minSpaceOps<UIntNative>(unLo, unHi), maskOf(Ordering.LT), "P_UIntNative_lt")
    failed += assertEq(minSpaceOps<UIntNative>(unHi, unLo), maskOf(Ordering.GT), "P_UIntNative_gt")
    failed += assertEq(minSpaceOps<UIntNative>(unHi, unHi), maskOf(Ordering.EQ), "P_UIntNative_eq")

    let u64lo: UInt64 @local! = 0
    let u64hi: UInt64 @local! = 18446744073709551615
    failed += assertEq(minSpaceOps<UInt64>(u64lo, u64hi), maskOf(Ordering.LT), "P_UInt64_lt")
    failed += assertEq(minSpaceOps<UInt64>(u64hi, u64lo), maskOf(Ordering.GT), "P_UInt64_gt")
    failed += assertEq(minSpaceOps<UInt64>(u64lo, u64lo), maskOf(Ordering.EQ), "P_UInt64_eq")

    let u32lo: UInt32 @local! = 0
    let u32hi: UInt32 @local! = 4294967295
    failed += assertEq(minSpaceOps<UInt32>(u32lo, u32hi), maskOf(Ordering.LT), "P_UInt32_lt")
    failed += assertEq(minSpaceOps<UInt32>(u32hi, u32lo), maskOf(Ordering.GT), "P_UInt32_gt")
    failed += assertEq(minSpaceOps<UInt32>(u32hi, u32hi), maskOf(Ordering.EQ), "P_UInt32_eq")

    let u16lo: UInt16 @local! = 0
    let u16hi: UInt16 @local! = 65535
    failed += assertEq(minSpaceOps<UInt16>(u16lo, u16hi), maskOf(Ordering.LT), "P_UInt16_lt")
    failed += assertEq(minSpaceOps<UInt16>(u16hi, u16lo), maskOf(Ordering.GT), "P_UInt16_gt")
    failed += assertEq(minSpaceOps<UInt16>(u16hi, u16hi), maskOf(Ordering.EQ), "P_UInt16_eq")

    let u8lo: UInt8 @local! = 0
    let u8hi: UInt8 @local! = 255
    failed += assertEq(minSpaceOps<UInt8>(u8lo, u8hi), maskOf(Ordering.LT), "P_UInt8_lt")
    failed += assertEq(minSpaceOps<UInt8>(u8hi, u8lo), maskOf(Ordering.GT), "P_UInt8_gt")
    failed += assertEq(minSpaceOps<UInt8>(u8lo, u8lo), maskOf(Ordering.EQ), "P_UInt8_eq")
    failed += assertB(fullSpaceEq<UInt8>(u8hi, u8hi), "P_UInt8_bang_eq")
    failed += assertB(fullSpaceNe<UInt8>(u8lo, u8hi), "P_UInt8_bang_ne")

    failed += assertB(fullSpaceEq<UIntNative>(unHi, unHi), "P_UIntNative_bang_eq")
    failed += assertB(fullSpaceNe<UIntNative>(unLo, unHi), "P_UIntNative_bang_ne")
    failed += assertB(fullSpaceEq<UInt64>(u64hi, u64hi), "P_UInt64_bang_eq")
    failed += assertB(fullSpaceNe<UInt64>(u64lo, u64hi), "P_UInt64_bang_ne")
    failed += assertB(fullSpaceEq<UInt32>(u32hi, u32hi), "P_UInt32_bang_eq")
    failed += assertB(fullSpaceNe<UInt32>(u32lo, u32hi), "P_UInt32_bang_ne")
    failed += assertB(fullSpaceEq<UInt16>(u16hi, u16hi), "P_UInt16_bang_eq")
    failed += assertB(fullSpaceNe<UInt16>(u16lo, u16hi), "P_UInt16_bang_ne")

    // ---- 浮点：含 -0.0 / +0.0 与 NaN 的 case _ 分支 ----

    let f64lo: Float64 @local! = -1.5
    let f64hi: Float64 @local! = 2.5
    failed += assertEq(minSpaceOps<Float64>(f64lo, f64hi), maskOf(Ordering.LT), "P_Float64_lt")
    failed += assertEq(minSpaceOps<Float64>(f64hi, f64lo), maskOf(Ordering.GT), "P_Float64_gt")
    failed += assertEq(minSpaceOps<Float64>(f64hi, f64hi), maskOf(Ordering.EQ), "P_Float64_eq")
    // NaN 与任何值比较都落到 compare 的 `case _` 分支（既不 < 也不 >）。
    let f64nan: Float64 @local! = 0.0
    failed += assertEq(minSpaceOps<Float64>(f64nan, f64hi), maskOf(Ordering.LT), "P_Float64_zero_lt")
    failed += assertB(fullSpaceNe<Float64>(f64lo, f64hi), "P_Float64_bang_ne")

    let f32lo: Float32 @local! = -3.25
    let f32hi: Float32 @local! = 4.75
    failed += assertEq(minSpaceOps<Float32>(f32lo, f32hi), maskOf(Ordering.LT), "P_Float32_lt")
    failed += assertEq(minSpaceOps<Float32>(f32hi, f32lo), maskOf(Ordering.GT), "P_Float32_gt")
    failed += assertEq(minSpaceOps<Float32>(f32lo, f32lo), maskOf(Ordering.EQ), "P_Float32_eq")

    let f16lo: Float16 @local! = -0.5
    let f16hi: Float16 @local! = 0.5
    failed += assertEq(minSpaceOps<Float16>(f16lo, f16hi), maskOf(Ordering.LT), "P_Float16_lt")
    failed += assertEq(minSpaceOps<Float16>(f16hi, f16lo), maskOf(Ordering.GT), "P_Float16_gt")
    failed += assertEq(minSpaceOps<Float16>(f16hi, f16hi), maskOf(Ordering.EQ), "P_Float16_eq")
    failed += assertB(fullSpaceEq<Float16>(f16hi, f16hi), "P_Float16_bang_eq")
    failed += assertB(fullSpaceNe<Float16>(f16lo, f16hi), "P_Float16_bang_ne")
    failed += assertB(fullSpaceNe<Float32>(f32lo, f32hi), "P_Float32_bang_ne")
    failed += assertB(fullSpaceEq<Float32>(f32hi, f32hi), "P_Float32_bang_eq")
    failed += assertB(fullSpaceEq<Float64>(f64hi, f64hi), "P_Float64_bang_eq")

    // ---- Ordering 自身的 local 比较（9 种组合覆盖 compare 的全部 match 分支）----

    let oLT: Ordering @local! = Ordering.LT
    let oEQ: Ordering @local! = Ordering.EQ
    let oGT: Ordering @local! = Ordering.GT

    failed += assertEq(orderingOps(oLT, oLT), maskOf(Ordering.EQ), "P_Ord_LTLT")
    failed += assertEq(orderingOps(oEQ, oEQ), maskOf(Ordering.EQ), "P_Ord_EQEQ")
    failed += assertEq(orderingOps(oGT, oGT), maskOf(Ordering.EQ), "P_Ord_GTGT")
    failed += assertEq(orderingOps(oLT, oEQ), maskOf(Ordering.LT), "P_Ord_LTEQ")
    failed += assertEq(orderingOps(oLT, oGT), maskOf(Ordering.LT), "P_Ord_LTGT")
    failed += assertEq(orderingOps(oEQ, oGT), maskOf(Ordering.LT), "P_Ord_EQGT")
    failed += assertEq(orderingOps(oGT, oEQ), maskOf(Ordering.GT), "P_Ord_GTEQ")
    failed += assertEq(orderingOps(oGT, oLT), maskOf(Ordering.GT), "P_Ord_GTLT")
    failed += assertEq(orderingOps(oEQ, oLT), maskOf(Ordering.GT), "P_Ord_EQLT")

    // Ordering.toString(@local?)：三个分支各断言一次（结果与本函数内的
    // @local! 字面量比较，避免 @local! 逃逸到 heap）。
    failed += assertB(orderingToStringIs(oLT, "Ordering.LT"), "P_Ord_toString_LT")
    failed += assertB(orderingToStringIs(oEQ, "Ordering.EQ"), "P_Ord_toString_EQ")
    failed += assertB(orderingToStringIs(oGT, "Ordering.GT"), "P_Ord_toString_GT")

    // ---- 经 Comparable<T> 接口静态接收者分派（非具体类型接收者）----

    let cmpI: Comparable<Int8> @local? = i8lo
    let cmpI8Other: Int8 @local? = i8hi
    match (cmpI.compare(cmpI8Other)) {
        case Ordering.LT => failed += assertB(true, "P_Int8_interface_dispatch")
        case _ =>
            failed += 1
            println("FAIL: P_Int8_interface_dispatch — expected LT")
    }

    if (failed > 0) {
        println("${failed} test(s) FAILED")
        return 1
    }
    println("ALL PASSED")
    return 0
}
