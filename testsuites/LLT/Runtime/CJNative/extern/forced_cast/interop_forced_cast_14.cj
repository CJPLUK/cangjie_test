// Forced-cast operand is a normal class member whose declared type is
// Extern<DummyRuntime>. This verifies that ordinary class member access remains
// usable as the operand expression and is not confused with extern e.f sugar.

import std.interop.*

class DummyRuntime <: Runtime<DummyRuntime> {
    public static func memberAccess(e: Extern<DummyRuntime>, field: String): Extern<DummyRuntime> {
        return e
    }

    public static func indexAccess(e: Extern<DummyRuntime>, arg: Any): Extern<DummyRuntime> {
        return e
    }

    public static func memberUpdate(e: Extern<DummyRuntime>, field: String, value: Any): Unit {
    }

    public static func indexUpdate(e: Extern<DummyRuntime>, field: Any, value: Any): Unit {
    }

    public static func functionCall(e: Extern<DummyRuntime>, args: Array<Any>): Extern<DummyRuntime> {
        return e
    }

    public static func fromExtern<R>(h: Extern<DummyRuntime>): R {
        throw Exception("dummy runtime stub")
    }

    public static func toExtern<R>(v: R): Extern<DummyRuntime> {
        return Extern<DummyRuntime>(v)
    }
}

class foo {}

class Holder {
    public let item: Extern<DummyRuntime>

    public init(item: Extern<DummyRuntime>) {
        this.item = item
    }
}

func makeExtern(): Extern<DummyRuntime> {
    return Extern<DummyRuntime>(0)
}

main() {
    let holder = Holder(makeExtern())
    let value: foo = (foo)holder.item
}
