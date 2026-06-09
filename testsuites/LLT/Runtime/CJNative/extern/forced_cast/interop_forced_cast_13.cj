// Negative case: the target is a syntactic generic type, but the operand is
// not Extern<T>. Direct forced cast should be rejected by sema.

class Box<T> {}

main() {
    let value: Box<Int64> = (Box<Int64>)1
}
