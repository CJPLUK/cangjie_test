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
// 覆盖 `hashable.cj` 为每个 Hashable 类型新增的 hashCode(this @local!)。
//
// 该文件为 Ordering / Unit / Bool / Rune / IntNative / Int64 / Int32 / Int16 /
// Int8 / UIntNative / UInt64 / UInt32 / UInt16 / UInt8 / Float64 / Float32 /
// Float16 各新增一个 `hashCode(this @local!)`，此前的用例只覆盖少数类型。
// 浮点的实现含 `this == 0.0` 的零值分支，Bool 含 true/false 两分支，因此
// 每个类型都取两个不同值（含零值与极值）以走到比较的两侧。

import std.core.*

// 每类型的 local hashCode 是否自身稳定，且与 heap 形态结果一致。
// 只断言稳定性与"堆/局部一致"，不依赖具体哈希算法，也不引入 T 的额外约束。
func hashStable<T>(a: T @local!): Int64 where T <: Hashable {
    exclave {
        let x: T @local? = a
        let h1: Int64 = x.hashCode()
        let h2: Int64 = x.hashCode()
        var r: Int64 = 0
        if (h1 != h2) { r += 1 }
        let full: T @local! = a
        if (full.hashCode() != h1) { r += 2 }
        r
    }
}

// 只实现 plain hashCode 的 conformer：Hashable 的两个 local 默认体必须抛。
class OnlyPlainHash <: Hashable {
    let v: Int64
    init(v: Int64) { this.v = v }
    exclave init(this @local!, v: Int64 @local!) { this.v = v }
    public func hashCode(): Int64 { v }
}

func hashDefaultThrowsHalf(x: OnlyPlainHash @local?): Bool {
    var caught = false
    try {
        let _: Int64 = x.hashCode()
    } catch (e: UnimplementedException) {
        caught = true
    }
    caught
}

func hashDefaultThrowsFull(x: OnlyPlainHash @local!): Bool {
    exclave {
        var caught = false
        try {
            let _: Int64 = x.hashCode()
        } catch (e: UnimplementedException) {
            caught = true
        }
        caught
    }
}

main(): Int64 {
    var failed = 0
    let seedForDefault: Int64 @local! = 7

    // ---- Ordering ----
    let oLT: Ordering @local! = Ordering.LT
    let oGT: Ordering @local! = Ordering.GT
    failed += assertEq(hashStable<Ordering>(oLT), 0, "H_Ordering")

    // ---- Ordering.hashCode(@local!) 的三条分支（GT/LT/EQ）----
    var ordHits = 0
    let ordLT: Ordering @local! = Ordering.LT
    let ordEQ: Ordering @local! = Ordering.EQ
    let ordGT: Ordering @local! = Ordering.GT
    if (ordLT.hashCode() == 1) { ordHits += 1 }
    if (ordGT.hashCode() == 3) { ordHits += 1 }
    if (ordEQ.hashCode() == 2) { ordHits += 1 }
    failed += assertEq(ordHits, 3, "H_Ordering_branch_values")

    // ---- Unit / Bool ----
    let u1: Unit @local! = ()
    failed += assertEq(hashStable<Unit>(u1), 0, "H_Unit")
    failed += assertEq(u1.hashCode(), 0, "H_Unit_zero")

    // ---- 浮点的非零分支（走 CJ_CORE_Float*ToHash）----
    let f64nz: Float64 @local! = 1.25
    failed += assertEq(hashStable<Float64>(f64nz), 0, "H_Float64_nonzero")
    let f32nz: Float32 @local! = 1.5
    failed += assertEq(hashStable<Float32>(f32nz), 0, "H_Float32_nonzero")
    let f16nz: Float16 @local! = 1.5
    failed += assertEq(hashStable<Float16>(f16nz), 0, "H_Float16_nonzero")
    let bT: Bool @local! = true
    let bF: Bool @local! = false
    failed += assertEq(hashStable<Bool>(bT), 0, "H_Bool")

    // ---- Rune ----
    let rA: Rune @local! = r'a'
    let rB: Rune @local! = r'z'
    failed += assertEq(hashStable<Rune>(rA), 0, "H_Rune")

    // ---- 有符号整数（含零值与极值）----
    let i64z: Int64 @local! = 0
    let i64m: Int64 @local! = -9223372036854775808
    failed += assertEq(hashStable<Int64>(i64z), 0, "H_Int64")
    let inZ: IntNative @local! = 0
    let inM: IntNative @local! = -128
    failed += assertEq(hashStable<IntNative>(inZ), 0, "H_IntNative")
    let i32z: Int32 @local! = 0
    let i32m: Int32 @local! = -2147483648
    failed += assertEq(hashStable<Int32>(i32z), 0, "H_Int32")
    let i16z: Int16 @local! = 0
    let i16m: Int16 @local! = -32768
    failed += assertEq(hashStable<Int16>(i16z), 0, "H_Int16")
    let i8z: Int8 @local! = 0
    let i8m: Int8 @local! = -128
    failed += assertEq(hashStable<Int8>(i8z), 0, "H_Int8")

    // ---- 无符号整数 ----
    let unZ: UIntNative @local! = 0
    let unM: UIntNative @local! = 255
    failed += assertEq(hashStable<UIntNative>(unZ), 0, "H_UIntNative")
    let u64z: UInt64 @local! = 0
    let u64m: UInt64 @local! = 18446744073709551615
    failed += assertEq(hashStable<UInt64>(u64z), 0, "H_UInt64")
    let u32z: UInt32 @local! = 0
    let u32m: UInt32 @local! = 4294967295
    failed += assertEq(hashStable<UInt32>(u32z), 0, "H_UInt32")
    let u16z: UInt16 @local! = 0
    let u16m: UInt16 @local! = 65535
    failed += assertEq(hashStable<UInt16>(u16z), 0, "H_UInt16")
    let u8z: UInt8 @local! = 0
    let u8m: UInt8 @local! = 255
    failed += assertEq(hashStable<UInt8>(u8z), 0, "H_UInt8")

    // ---- 浮点（零值分支 + 非零分支）----
    let f64z: Float64 @local! = 0.0
    let f64n: Float64 @local! = -1.5
    failed += assertEq(hashStable<Float64>(f64z), 0, "H_Float64")
    let f32z: Float32 @local! = 0.0
    let f32n: Float32 @local! = -3.25
    failed += assertEq(hashStable<Float32>(f32z), 0, "H_Float32")
    let f16z: Float16 @local! = 0.0
    let f16n: Float16 @local! = -0.5
    failed += assertEq(hashStable<Float16>(f16z), 0, "H_Float16")

    // ---- Hashable 接口的两个 local 默认体（未覆写时必须抛精确异常）----
    // String 有自己的 hashCode(@local?) 覆写，因此用一个只实现 plain hashCode
    // 的 conformer 来触发接口默认体。
    let onlyPlainLocal: OnlyPlainHash @local! = OnlyPlainHash(seedForDefault) @local!
    failed += assertB(hashDefaultThrowsFull(onlyPlainLocal), "H_default_local_bang_throws")
    let onlyPlainHeap = OnlyPlainHash(7)
    let onlyPlainHalf: OnlyPlainHash @local? = onlyPlainHeap
    failed += assertB(hashDefaultThrowsHalf(onlyPlainHalf), "H_default_local_half_throws")

    // ---- Array.toString(@local?)：非空（size>0 的两条循环分支）与空 ----
    let nonEmpty: Array<Int64> @local! = [1, 2, 3]
    let nonEmptyQ: Array<Int64> @local? = nonEmpty
    let text: String @local! = nonEmptyQ.toString()
    failed += assertB(text.size > 0, "A_toString_nonempty")
    let emptyArr: Array<Int64> @local! = []
    let emptyQ: Array<Int64> @local? = emptyArr
    let emptyText: String @local! = emptyQ.toString()
    failed += assertB(emptyText.size == 2, "A_toString_empty_brackets")

    // ---- Array 的空构造（走 rawArrayAllocate3 的 size=0 分支）----
    let zeroArr: Array<Int64> @local! = Array<Int64>() @local!
    failed += assertEq(zeroArr.size, 0, "A_empty_ctor_size")

    if (failed > 0) {
        println("${failed} test(s) FAILED")
        return 1
    }
    println("ALL PASSED")
    return 0
}
