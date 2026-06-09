// Negative case: `(foo)(1)` has both a forced-cast candidate and the original
// parenthesized-call fallback shape. Since `foo` is a type but `1` is not
// Extern<T>, forced cast must not be selected; the original fallback path then
// fails with the normal type-name-as-call diagnostic.

class foo {}

main() {
    let value = (foo)(1)
}
