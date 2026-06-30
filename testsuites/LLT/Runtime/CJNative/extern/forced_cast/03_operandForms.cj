// Copyright (c) Huawei Technologies Co., Ltd. 2025. All rights reserved.
// This source file is part of the Cangjie project, licensed under Apache-2.0
// with Runtime Library Exception.
//
// See https://cangjie-lang.cn/pages/LICENSE for license information.

// EXEC-0: %compiler %cmp_opt %f -o %output
// RUN-EXEC: %run %run_opt %output %run_args

// The forced-cast operand may take several shapes, all resolving via
// Runtime.fromExtern: a call expression, an Extern member access (`e.f`), an
// Extern index access (`e[i]`), and an ordinary class member whose type is
// Extern. Recall a forced cast binds looser than postfix, so `(Foo)e.f` is
// `(Foo)(e.f)`: the member/index access happens first (staying Extern), then the
// cast extracts the payload.

class DummyRuntime <: Runtime<DummyRuntime> {
    public static func memberAccess(e: Extern<DummyRuntime>, field: String): Extern<DummyRuntime> { return e }
    public static func indexAccess(e: Extern<DummyRuntime>, arg: Any): Extern<DummyRuntime> { return e }
    public static func memberUpdate(e: Extern<DummyRuntime>, field: String, value: Any): Unit {}
    public static func indexUpdate(e: Extern<DummyRuntime>, field: Any, value: Any): Unit {}
    public static func functionCall(e: Extern<DummyRuntime>, args: Array<Any>): Extern<DummyRuntime> { return e }
    public static func fromExtern<R>(h: Extern<DummyRuntime>): R { return (getPayload(h) as R).getOrThrow() }
    public static func toExtern<R>(v: R): Extern<DummyRuntime> { return Extern<DummyRuntime>(v) }
}

class Foo {
    let id: Int64
    public init(id: Int64) { this.id = id }
}

class Holder {
    public let item: Extern<DummyRuntime>
    public init(item: Extern<DummyRuntime>) { this.item = item }
}

func makeFooExtern(id: Int64): Extern<DummyRuntime> {
    return Extern<DummyRuntime>(Foo(id))
}

main() {
    let e = makeFooExtern(7)

    // call operand
    let fromCall: Foo = (Foo)makeFooExtern(7)
    // Extern member-access operand: (Foo)(e.field)
    let fromMember: Foo = (Foo)e.field
    // Extern index-access operand: (Foo)(e[0])
    let fromIndex: Foo = (Foo)e[0]
    // ordinary class member whose type is Extern
    let holder = Holder(makeFooExtern(7))
    let fromNormalMember: Foo = (Foo)holder.item

    if (fromCall.id != 7 || fromMember.id != 7 || fromIndex.id != 7 || fromNormalMember.id != 7) {
        throw Exception("operand form forced cast failed")
    }
}
