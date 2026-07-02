// Copyright (c) Huawei Technologies Co., Ltd. 2025. All rights reserved.
// This source file is part of the Cangjie project, licensed under Apache-2.0
// with Runtime Library Exception.
//
// See https://cangjie-lang.cn/pages/LICENSE for license information.

// EXEC-0: %compiler %cmp_opt %f -o %output
// RUN-EXEC: %run %run_opt %output %run_args

// Nested and irregular ambiguity. Every parenthesized type-shaped construct is
// independently ambiguous, so a deep expression must resolve forced-cast vs
// ordinary-call per layer in any order (FC over call over FC, etc.), and trailing
// operators / postfix must attach to the right layer.

class DummyRuntime <: Runtime<DummyRuntime> {
    public static func memberAccess(e: Extern<DummyRuntime>, field: String): Extern<DummyRuntime> { return e }
    public static func indexAccess(e: Extern<DummyRuntime>, arg: Any): Extern<DummyRuntime> { return e }
    public static func memberUpdate(e: Extern<DummyRuntime>, field: String, value: Any): Unit {}
    public static func indexUpdate(e: Extern<DummyRuntime>, field: Any, value: Any): Unit {}
    public static func functionCall(e: Extern<DummyRuntime>, args: Array<Any>): Extern<DummyRuntime> { return e }
    public static func fromExtern<R>(h: Extern<DummyRuntime>): R { return (Extern<DummyRuntime>.getPayload(h) as R).getOrThrow() }
    public static func toExtern<R>(v: R): Extern<DummyRuntime> { return Extern<DummyRuntime>(v) }
}

class User {
    let id: Int64
    public init(id: Int64) { this.id = id }
}

func consume(value: Extern<DummyRuntime>): User { (User)value }
// identity passthrough: an ordinary-call layer that returns its Extern operand.
func id(e: Extern<DummyRuntime>): Extern<DummyRuntime> { e }
func makeUserExtern(n: Int64): Extern<DummyRuntime> { Extern<DummyRuntime>(User(n)) }
func makeNested(n: Int64): Extern<DummyRuntime> { Extern<DummyRuntime>(Extern<DummyRuntime>(User(n))) }
func makeIntExtern(n: Int64): Extern<DummyRuntime> { Extern<DummyRuntime>(n) }

// Each layer can require a different sema decision; nested AmbiguousForcedCastExpr
// nodes must select branches independently.
func checkRecursiveAmbiguity(): Unit {
    let nested = Extern<DummyRuntime>(Extern<DummyRuntime>(User(1)))
    let triple = Extern<DummyRuntime>(Extern<DummyRuntime>(Extern<DummyRuntime>(User(2))))

    let selectedForcedCast: User = (User)((Extern<DummyRuntime>)nested)
    let selectedFallbackCall: User = (consume)((Extern<DummyRuntime>)nested)
    let twoForcedAmbiguities: User = (User)((Extern<DummyRuntime>)(nested))
    let threeForcedAmbiguities: User =
        (User)((Extern<DummyRuntime>)((Extern<DummyRuntime>)(triple)))
    let fallbackAroundAmbiguity: User = (consume)((Extern<DummyRuntime>)(nested))
    let forcedAroundFallback: User = (User)((makeUserExtern)(3))
    let extendedForcedAroundFallback = (Int64)((makeIntExtern)(4)) + 1

    if (selectedForcedCast.id != 1 || selectedFallbackCall.id != 1 ||
        twoForcedAmbiguities.id != 1 || threeForcedAmbiguities.id != 2 ||
        fallbackAroundAmbiguity.id != 1 || forcedAroundFallback.id != 3 ||
        extendedForcedAroundFallback != 5) {
        throw Exception("recursive ambiguity failed")
    }
}

// Irregular FC / ordinary-call alternation across layers, with trailing operators.
func checkIrregularNesting(): Unit {
    let fcOverCall: User = (User)((makeUserExtern)(5))
    let nested = makeNested(6)
    let fcCallFc: User = (User)((id)((Extern<DummyRuntime>)(nested)))
    let fourLayers: User = (User)((Extern<DummyRuntime>)((id)((makeNested)(7))))
    let trailingOuter = (Int64)((id)((makeIntExtern)(4))) + 1
    let trailingDeep = (Int64)((id)((id)((makeIntExtern)(10)))) + 1 * 2
    let memberOnResult = ((User)((id)((makeUserExtern)(8)))).id
    let pair = (((User)((id)((makeUserExtern)(1)))).id, (Int64)((id)((makeIntExtern)(2))) + 100)

    if (fcOverCall.id != 5 || fcCallFc.id != 6 || fourLayers.id != 7 ||
        trailingOuter != 5 || trailingDeep != 12 || memberOnResult != 8 ||
        pair[0] != 1 || pair[1] != 102) {
        throw Exception("irregular nesting failed")
    }
}

main() {
    checkRecursiveAmbiguity()
    checkIrregularNesting()
}
