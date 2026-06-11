// EXEC-0: %compiler %cmp_opt %f -o %output

// Current compiler: should compile.
// After forced-cast implementation: should still compile and stay on the
// original parenthesized-call path instead of becoming a forced cast.

func foo(x: Int64): Int64 {
    return x + 1
}

main() {
    let value = (foo)(1)
    let baseline = foo(1)
    let same = value == baseline
}
