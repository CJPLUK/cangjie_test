// Copyright (c) Huawei Technologies Co., Ltd. 2026. All rights reserved.
// This source file is part of the Cangjie project, licensed under Apache-2.0
// with Runtime Library Exception.
//
// See https://cangjie-lang.cn/pages/LICENSE for license information.

// LEVEL: 0
// Positive: NoSideEffectMarker sets Attribute::NO_SIDE_EFFECT on whitelist
// entries (hashCode / compare / String.== / math.round) in Canonicalization.
// DEPENDENCE: ../pick_defination.py
// EXEC: %compiler %cmp_opt %dumpCHIRDebug -Woff all %n.cj
// EXEC: %python pick_defination.py default_CHIR/[0-9]*_Canonicalization.chirtxt WHOLE | compare %f

import std.math.*

main() {
    round(0.01f16)
    round(0.01f32)
    round(0.01f64)
    let x: Int64 = 1
    x.hashCode()
    let y: Float64 = 1.0
    y.hashCode()
    let s = "a"
    s == "b"
    s.compare("c")
    Ordering.LT.compare(Ordering.GT)
    0
}

// extend Ordering { public func compare(other: Ordering): Ordering }
// ASSERT: regex-begin \[noSideEffect\].* @_CNatXNNat8OrderingE7compareHY1_\(
// ASSERT: regex-after packageName: std.core

// extend Int64 { public func hashCode(): Int64 }
// ASSERT: regex-begin \[noSideEffect\].* @_CNatXl8hashCodeHv\(
// ASSERT: regex-after packageName: std.core

// extend Float64 { public func hashCode(): Int64 }
// ASSERT: regex-begin \[noSideEffect\].* @_CNatXd8hashCodeHv\(
// ASSERT: regex-after packageName: std.core

// struct String { public func compare(str: String): Ordering }
// ASSERT: regex-begin \[noSideEffect\].* @_CNat6String7compareHRNatY0_E\(
// ASSERT: regex-after packageName: std.core

// struct String { public operator func ==(other: String): Bool }
// ASSERT: regex-begin \[noSideEffect\].* @_CNat6StringeqHRNatY0_E\(
// ASSERT: regex-after packageName: std.core

// public func round(x: Float64): Float64
// ASSERT: regex-begin \[noSideEffect\].* @_CNbg5roundHd\(
// ASSERT: regex-after packageName: std.math

// public func round(x: Float32): Float32
// ASSERT: regex-begin \[noSideEffect\].* @_CNbg5roundHf\(
// ASSERT: regex-after packageName: std.math

// public func round(x: Float16): Float16
// ASSERT: regex-begin \[noSideEffect\].* @_CNbg5roundHDh\(
// ASSERT: regex-after packageName: std.math
