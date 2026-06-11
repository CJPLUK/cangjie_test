// EXEC-0: %compiler %cmp_opt %f -o %output

// Similar surface shape, but not a forced-cast candidate: the text inside
// parentheses is an expression, not a syntactic type. This must keep the old
// parenthesized-expression path.

main() {
    let foo: Int64 = 10
    let bar: Int64 = 20
    let value = (foo + bar)
    let same = value == 30
}
