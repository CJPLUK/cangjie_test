// EXEC: %compiler %enableEH %core_cmp_opt  %f -o %output
// EXEC-PIPE-0: %run %set_stdx_path %output | compare %f
// ASSERT: scan-not core dumped
// ASSERT: scan-not stack trace

import stdx.effect.{Command, Resumption}
import std.collection.HashMap

class Fibonacci <: Command<Int64> & Hashable & Equatable<Fibonacci> {
    Fibonacci(let n: Int64) {}
    public override func defaultImpl() {
        if (n <= 1) {
            1
        } else {
            fibonacci(n-1) + fibonacci(n-2)
        }
    }
    public override operator func ==(other: Fibonacci) { this.n == other.n }
    public override operator func !=(other: Fibonacci) { this.n != other.n }

    public override func hashCode() { this.n.hashCode() }
}
func fibonacci(n: Int64) { perform Fibonacci(n) }

func withCache<Cmd, Result, Return>(fn: () -> Return): Return
where Cmd <: Hashable & Equatable<Cmd> & Command<Result>
{
    let cache = HashMap<Cmd, Result>()
    let result: Box<Option<Return>> = Box(None)
    try {
        result.value = fn()
    } handle (cmd: Cmd, next: Resumption<Result, Unit>) {
        let result = match (cache.get(cmd)) {
            case None =>
                let result = perform cmd
                cache.add(cmd, result)
                result
            case Some(cached) =>
                cached
        }
        resume next with result
    }
    result.value.getOrThrow()
}

func printAllFibonacci() {
    let N = 5
    let input = 15
    for (_ in 0 .. N) {
        println("fibonacci(${input}) = ${fibonacci(input)}")
    }
}
main() {
    println("Without cache")
    printAllFibonacci()

    withCache<Fibonacci, Int64, Unit> {
        println("With cache")
        printAllFibonacci()
    }
}
