// EXEC-0: %compiler %cmp_opt %f -o %output
// RUN-EXEC: %run %run_opt %output %run_args

open class ConvertBase<E> {
    public static func toExtern<T>(value: T): E {
        // For RT, E is exactly Extern<RT>, so this cast succeeds.
        (Extern<RT>(value) as E).getOrThrow()
    }
}

class RT <: ConvertBase<Extern<RT>> & ForeignRuntime<RT> {
    // Other required members; none is called by this example.
    public static func fromExtern<T>(e: Extern<RT>): T { throw Exception() }
    public static func memberAccess(e: Extern<RT>, name: String): Extern<RT> { throw Exception() }
    public static func indexedAccess(e: Extern<RT>, index: Any): Extern<RT> { throw Exception() }
    public static func memberUpdate(e: Extern<RT>, name: String, value: Any): Unit { throw Exception() }
    public static func indexedUpdate(e: Extern<RT>, index: Any, value: Any): Unit { throw Exception() }
    public static func functionCall(e: Extern<RT>, args: Array<Any>): Extern<RT> { throw Exception() }
}

main() {
    let actual: Extern<RT> = 7
    if ((Extern<RT>.getPayload(actual) as Int64).getOrThrow() != 7) {
        throw Exception("unexpected conversion payload")
    }
    0
}
