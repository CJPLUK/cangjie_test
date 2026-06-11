// EXEC-PIPE-1: %compiler %cmp_opt %f -o %output 2>&1 | compare %f
// ASSERT: scan invalid interoperation forced cast
// ASSERT: scan requires 'U' to be a type and 'e' to be an expression of 'std.interop.Extern' type
// ASSERT: scan use 'as' for ordinary type conversions

// Negative case: `(foo)1` has only the forced-cast parse shape, but the operand
// is not Extern<T>. The implementation must reject it instead of fabricating a
// conversion from ordinary Int64.

class foo {}

main() {
    let value: foo = (foo)1
}
