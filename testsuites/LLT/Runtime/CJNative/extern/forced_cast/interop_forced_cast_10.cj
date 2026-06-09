// Negative shape case: this looks like a forced-cast operand using extern
// member access, but the current local runtime stub does not enable e.f
// interop sugar. It should fail as an ordinary member lookup on Extern.

interface Runtime<T> where T <: Runtime<T> {
    static func memberAccess(e: Extern<T>, field: String): Extern<T>
    static func indexAccess(e: Extern<T>, arg: Any): Extern<T>
    static func memberUpdate(e: Extern<T>, field: String, value: Any): Unit
    static func indexUpdate(e: Extern<T>, field: Any, value: Any): Unit
    static func functionCall(e: Extern<T>, args: Array<Any>): Extern<T>
    static func fromExtern<R>(h: Extern<T>): R
    static func toExtern<R>(v: R): Extern<T>
}

struct Extern<T> where T <: Runtime<T> {
    Extern(public let content: Any) {}
}

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
    let value: foo = (foo)externValue.name
}
