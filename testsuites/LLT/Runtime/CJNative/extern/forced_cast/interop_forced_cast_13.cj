// EXEC-PIPE-1: %compiler %cmp_opt %f -o %output 2>&1 | compare %f
// ASSERT: scan invalid interoperation forced cast
// ASSERT: scan requires 'U' to be a type and 'e' to be an expression of 'std.interop.Extern' type
// ASSERT: scan use 'as' for ordinary type conversions

// Negative case: the target is a syntactic generic type, but the operand is
// not Extern<T>. Direct forced cast should be rejected by sema.

class Box<T> {}

main() {
    let value: Box<Int64> = (Box<Int64>)1
}
