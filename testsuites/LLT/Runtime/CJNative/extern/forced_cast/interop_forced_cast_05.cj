// Current compiler: should fail.
// After forced-cast implementation: should compile and be resolved as
// `ForcedCastExpr(targetType = Box<Int64>, operand = externValue)`.

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

class Box<T> {}

func makeExtern(): Extern<DummyRuntime> {
    return Extern<DummyRuntime>(0)
}

main() {
    let externValue = makeExtern()
    let value: Box<Int64> = (Box<Int64>)externValue
}
