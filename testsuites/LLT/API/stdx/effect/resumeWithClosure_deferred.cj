// EXEC: %compiler %enableEH %core_cmp_opt  %f -o %output
// EXEC-PIPE-0: %run %set_stdx_path %output | compare %f
// ASSERT: scan-not core dumped
// ASSERT: scan-not stack trace

import stdx.effect.{Command, Resumption}
import std.collection.*

class Yield <: Command<(Int64) -> Any> {}

main() {
    try {
        let a = perform Yield()
        println("it is resumed")
        a(9)
    } handle(e: Yield, next: Resumption<(Int64) -> Any, Any>) {
        println("it is performed")
        resume next with {x: Int64 => println("x = ${x}")}
    }
    0
}
