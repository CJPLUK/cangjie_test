// EXEC-0: %compiler %cmp_opt %f -o %output

// Current compiler: should fail.
// After forced-cast implementation: should compile and be resolved as
// `ForcedCastExpr(targetType = foo, operand = ParenExpr(externValue))`.
//
// This file is the direct contrast case to `interop_forced_cast_02.cj`:
// there the left side is a function name and must stay on the old call path;
// here the left side is a type name and the operand is Extern, so the new
// forced-cast branch should win.

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

func makeExtern(): Extern<DummyRuntime> {
    return Extern<DummyRuntime>(0)
}

main() {
    let externValue = makeExtern()
    let value: foo = (foo)(externValue)
}
