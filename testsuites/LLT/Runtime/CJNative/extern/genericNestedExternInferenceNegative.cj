// RUN-EXEC-PIPE-1: %compiler %cmp_opt %f -o %output 2>&1 | compare %f
// ASSERT: scan expected 'Struct-Array<Struct-Extern<Class-RT>>', found 'Struct-Array<Int64>'
// ASSERT: scan cannot convert an integer literal to type 'Struct-Array<Struct-Extern<Class-RT>>'
// ASSERT: scan expected 'Tuple<Struct-Extern<Class-RT>, Int64>', found 'Tuple<Int64, Int64>'
// ASSERT: scan expected 'Int64', found 'Struct-String'
// ASSERT: scan expected 'Tuple<Struct-Extern<Class-RT>, Int64>', found 'Tuple<Int64, Int64, Int64>'
// ASSERT: scan expected '() -> Struct-Extern<Class-RT>', found '() -> Int64'
// ASSERT: scan expected 'Enum-Option<Struct-Extern<Class-RT>>', found 'Enum-Option<Int64>'
// ASSERT: scan expected 'Class-Box<Struct-Extern<Class-RT>>', found 'Class-Box<Int64>'
// ASSERT: scan-not Assertion

// The presence of Extern inside a concrete parameter does not make the entire
// parameter accept arbitrary values. Generic inference must still be followed
// by checking the actual expression against its original parameter type.
// Keep array parameters first to prevent variadic packing of the argument.

class RT <: ForeignRuntime<RT> {
    public static func memberAccess(_: Extern<RT>, _: String): Extern<RT> { throw Exception() }
    public static func indexedAccess(_: Extern<RT>, _: Any): Extern<RT> { throw Exception() }
    public static func memberUpdate(_: Extern<RT>, _: String, _: Any): Unit {}
    public static func indexedUpdate(_: Extern<RT>, _: Any, _: Any): Unit {}
    public static func functionCall(_: Extern<RT>, _: Array<Any>): Extern<RT> { throw Exception() }
    public static func fromExtern<R>(_: Extern<RT>): R { throw Exception() }
    public static func toExtern<R>(value: R): Extern<RT> { Extern<RT>(value) }
}

class Box<T> {
    let value: T
    init(value: T) { this.value = value }
}
func arrayArg<T>(_: Array<Extern<RT>>, _: T): Unit {}
func tupleArg<T>(_: (Extern<RT>, Int64), _: T): Unit {}
func functionArg<T>(_: () -> Extern<RT>, _: T): Unit {}
func optionArg<T>(_: ?Extern<RT>, _: T): Unit {}
func boxArg<T>(_: Box<Extern<RT>>, _: T): Unit {}
func plain(): Int64 { 1 }

main() {
    let array = [1, 2]
    let tuple = (1, 2)
    arrayArg(array, 0)              // No Array<Int64> -> Array<Extern<RT>> conversion.
    arrayArg(1, 0)                  // A scalar is not an array.
    tupleArg(tuple, 0)              // Only literal elements may be converted.
    tupleArg((1, "bad"), 0)         // The non-Extern element still requires Int64.
    tupleArg((1, 2, 3), 0)          // Tuple arity still matters.
    functionArg(plain, 0)           // Existing function values are not adapted.
    optionArg(Some<Int64>(1), 0)    // No structural Option conversion.
    boxArg(Box<Int64>(1), 0)        // No structural conversion of arbitrary wrappers.
}
