// Copyright (c) Huawei Technologies Co., Ltd. 2025. All rights reserved.
// This source file is part of the Cangjie project, licensed under Apache-2.0
// with Runtime Library Exception.
//
// See https://cangjie-lang.cn/pages/LICENSE for license information.

// EXEC-0: %compiler %cmp_opt %f -o %output
// RUN-EXEC: %run %run_opt %output %run_args

// Precedence of a forced cast relative to other operators:
//   * Looser than postfix (`.`, `[]`): `(U)e.f` is `(U)(e.f)`; parenthesize the
//     cast to apply postfix to the result -- `((U)e).f`.
//   * Tighter than binary operators: `(U)e + 1` is `((U)e) + 1`.
// Also pins how postfix binds for the ordinary-call branch.

class DummyRuntime <: Runtime<DummyRuntime> {
    public static func memberAccess(e: Extern<DummyRuntime>, field: String): Extern<DummyRuntime> { return e }
    public static func indexAccess(e: Extern<DummyRuntime>, arg: Any): Extern<DummyRuntime> { return e }
    public static func memberUpdate(e: Extern<DummyRuntime>, field: String, value: Any): Unit {}
    public static func indexUpdate(e: Extern<DummyRuntime>, field: Any, value: Any): Unit {}
    public static func functionCall(e: Extern<DummyRuntime>, args: Array<Any>): Extern<DummyRuntime> { return e }
    public static func fromExtern<R>(h: Extern<DummyRuntime>): R { return (getPayload(h) as R).getOrThrow() }
    public static func toExtern<R>(v: R): Extern<DummyRuntime> { return Extern<DummyRuntime>(v) }
}

class Box {
    let value: Int64
    public init(value: Int64) { this.value = value }
    public func get(): Int64 { this.value }
}

class User {
    let id: Int64
    public init(id: Int64) { this.id = id }
}

class Holder {
    let handle: Extern<DummyRuntime>
    public init(handle: Extern<DummyRuntime>) { this.handle = handle }
}

func consume(value: Extern<DummyRuntime>): User { (User)value }
func makeUserExtern(id: Int64): Extern<DummyRuntime> { Extern<DummyRuntime>(User(id)) }
func makeIntExtern(value: Int64): Extern<DummyRuntime> { Extern<DummyRuntime>(value) }
func makeBoxExtern(value: Int64): Extern<DummyRuntime> { Extern<DummyRuntime>(Box(value)) }
func makeArrayExtern(): Extern<DummyRuntime> { Extern<DummyRuntime>([10, 20, 30]) }
func identity(x: Int64): Int64 { x }
func bodyContext(): Int64 { (Int64)((makeIntExtern)(4)) + 1 }
func returnContext(): Int64 { return (Int64)((makeIntExtern)(4)) + 1 }

// Reading a field off a forced-cast result inside a function-call argument is a
// synthesis context (no target type flows in from a typed `let`); the cast must
// still resolve there. Regression guard: this combination previously crashed sema.
// Use two classes to show it is the shape, not a particular type.
func checkFcResultFieldInArg(): Unit {
    let viaBox = identity(((Box)(makeBoxExtern(11))).value)
    let viaUser = identity(((User)(makeUserExtern(12))).id)
    if (viaBox != 11 || viaUser != 12) {
        throw Exception("forced-cast result field in argument failed")
    }
}

// Cast vs postfix: cast binds looser, so parens are needed to act on the result.
func checkPostfixPrecedence(): Unit {
    let methodOnResult: Int64 = ((Box)(makeBoxExtern(5))).get()
    let indexOnResult: Int64 = ((Array<Int64>)(makeArrayExtern()))[2]
    // Without extra parens the postfix binds to the operand (stays Extern), then
    // the cast extracts the payload, so the type is the cast target itself.
    let castOverOperandAccess: Box = (Box)(makeBoxExtern(9).get())
    if (methodOnResult != 5 || indexOnResult != 30 || castOverOperandAccess.get() != 9) {
        throw Exception("postfix precedence failed")
    }
}

// Cast vs binary: cast binds tighter, binary operators stay outside the cast.
func checkTrailingOperators(): Unit {
    let declared = (Int64)((makeIntExtern)(4)) + 1
    let usedLater = declared + 10
    let mixedPrecedence = (Int64)((makeIntExtern)(4)) + 1 * 2
    let tupled = ((Int64)((makeIntExtern)(4)) + 1, (Int64)((makeIntExtern)(2)) * 3)
    let matched = match ((Int64)((makeIntExtern)(4)) + 1) {
        case 5 => "five"
        case _ => "other"
    }
    let lambda: (Extern<DummyRuntime>) -> Int64 = { e => (Int64)e + 1 }
    let argResult = identity((Int64)((makeIntExtern)(4)) + 1)
    var counter = 0
    while (counter < (Int64)((makeIntExtern)(3)) + 0) {
        counter += 1
    }
    if (declared != 5 || usedLater != 15 || mixedPrecedence != 6 ||
        tupled[0] != 5 || tupled[1] != 6 || matched != "five" ||
        bodyContext() != 5 || returnContext() != 5 ||
        lambda(makeIntExtern(41)) != 42 || argResult != 5 || counter != 3) {
        throw Exception("trailing operator binding failed")
    }
}

// Postfix binding differs by which branch wins: a cast binds looser than `.`
// while an ordinary call is a normal postfix primary that `.f` chains after.
func checkCastVsCallBinding(): Unit {
    // (User)(holder.handle): only `(User)(holder.handle)` type-checks; the
    // alternative would forced-cast a non-Extern Holder.
    let holder = Holder(makeUserExtern(7))
    let castOverMember: User = (User)holder.handle
    // (User)e.id -> (User)(e.id): yields a User, not the Int64 that ((User)e).id would.
    let externValue = makeUserExtern(3)
    let castOverExternMember: User = (User)externValue.id
    // (consume)(e).id -> ((consume)(e)).id: call first, then member -> Int64.
    let callThenMember: Int64 = (consume)(makeUserExtern(9)).id
    if (castOverMember.id != 7 || castOverExternMember.id != 3 || callThenMember != 9) {
        throw Exception("cast vs call postfix binding failed")
    }
}

main() {
    checkPostfixPrecedence()
    checkTrailingOperators()
    checkCastVsCallBinding()
    checkFcResultFieldInArg()
}
