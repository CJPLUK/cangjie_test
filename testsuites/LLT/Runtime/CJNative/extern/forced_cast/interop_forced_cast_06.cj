// Negative case: `(foo)1` has only the forced-cast parse shape, but the operand
// is not Extern<T>. The implementation must reject it instead of fabricating a
// conversion from ordinary Int64.

class foo {}

main() {
    let value: foo = (foo)1
}
