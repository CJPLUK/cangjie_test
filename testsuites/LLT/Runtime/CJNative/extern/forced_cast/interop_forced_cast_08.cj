// EXEC-0: %compiler %cmp_opt %f -o %output

// Fallback case with an extended binary expression. This keeps the old
// expression path and verifies that operators after the ambiguous prefix are
// preserved inside the fallback branch.

main() {
    let foo: Int64 = 10
    let value = (foo)-1 * 2
    let baseline = (foo - 1) * 2
    let same = value == baseline
}
