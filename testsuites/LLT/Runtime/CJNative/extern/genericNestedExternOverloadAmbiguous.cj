// RUN-EXEC-PIPE-1: %compiler %cmp_opt %f -o %output 2>&1 | compare %f
// ASSERT: scan ambiguous match for function call 'choose'
// ASSERT: scan-not Assertion

// Both candidates accept the literal. Inference must not discard the candidate
// needing element conversion, and conversion cost does not break the tie.
// These invariant array types are unrelated, so neither is more specific.

class RT <: ForeignRuntime<RT> {
    public static func memberAccess(_: Extern<RT>, _: String): Extern<RT> { throw Exception() }
    public static func indexedAccess(_: Extern<RT>, _: Any): Extern<RT> { throw Exception() }
    public static func memberUpdate(_: Extern<RT>, _: String, _: Any): Unit {}
    public static func indexedUpdate(_: Extern<RT>, _: Any, _: Any): Unit {}
    public static func functionCall(_: Extern<RT>, _: Array<Any>): Extern<RT> { throw Exception() }
    public static func fromExtern<R>(_: Extern<RT>): R { throw Exception() }
    public static func toExtern<R>(value: R): Extern<RT> { Extern<RT>(value) }
}

func choose<T>(_: Array<Extern<RT>>, _: T): Int64 { 1 }
func choose<T>(_: Array<Int64>, _: T): Int64 { 2 }

main() {
    choose([1, 2], 0)
    0
}
