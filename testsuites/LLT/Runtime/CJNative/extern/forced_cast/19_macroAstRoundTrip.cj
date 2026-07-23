// Copyright (c) Huawei Technologies Co., Ltd. 2025. All rights reserved.
// This source file is part of the Cangjie project, licensed under Apache-2.0
// with Runtime Library Exception.
//
// See https://cangjie-lang.cn/pages/LICENSE for license information.

// DEPENDENCE: 19_macroAstRoundTrip_define.cj
// EXEC: %compiler %cmp_macro 19_macroAstRoundTrip_define.cj
// EXEC: %run_macro %compiler %cmp_opt %f -o %output
// RUN-EXEC: %run %run_opt %output %run_args

import forced_cast_macro.*

class DummyRuntime <: ForeignRuntime<DummyRuntime> {
    public static func memberAccess(e: Extern<DummyRuntime>, field: String): Extern<DummyRuntime> { e }
    public static func indexedAccess(e: Extern<DummyRuntime>, arg: Any): Extern<DummyRuntime> { e }
    public static func memberUpdate(e: Extern<DummyRuntime>, field: String, value: Any): Unit {}
    public static func indexedUpdate(e: Extern<DummyRuntime>, field: Any, value: Any): Unit {}
    public static func functionCall(e: Extern<DummyRuntime>, args: Array<Any>): Extern<DummyRuntime> { e }
    public static func fromExtern<R>(h: Extern<DummyRuntime>): R {
        (Extern<DummyRuntime>.getPayload(h) as R).getOrThrow()
    }
    public static func toExtern<R>(v: R): Extern<DummyRuntime> { Extern<DummyRuntime>(v) }
}

func identity(value: Int64): Int64 { value }

@DeclRoundTrip
func throughMacro(e: Extern<DummyRuntime>): Int64 {
    let direct = (Int64)e
    let parenthesized = (Int64)(e)
    let ordinaryCall = (identity)(3)
    let nestedMacro = (Int64)@ExprRoundTrip(e)
    let madeByMacro = @MakeForcedCast(e)
    let stripped: Extern<DummyRuntime> = @StripForcedCast((Int64)e)
    let wrappedByMacro = @WrapForcedCastOperand((Int64)e)
    let nestedThenWrapped = @WrapForcedCastOperand((Int64)@ExprRoundTrip(e))
    let nestedThenMade = @MakeForcedCast(@ExprRoundTrip(e))
    let retargeted = @RetargetForcedCast((String)e)
    let visitorRewritten = @RewriteForcedCastWithVisitor((Int64)undefinedOperand)
    let lambda = {value: Extern<DummyRuntime> => (Int64)value}
    direct + parenthesized + ordinaryCall + nestedMacro + madeByMacro +
        (Int64)stripped + wrappedByMacro + nestedThenWrapped + nestedThenMade + retargeted + visitorRewritten + lambda(e)
}

main() {
    let e = Extern<DummyRuntime>(5)
    if (throughMacro(e) != 58) {
        throw Exception("forced cast did not survive std.ast macro round-trip")
    }
}
