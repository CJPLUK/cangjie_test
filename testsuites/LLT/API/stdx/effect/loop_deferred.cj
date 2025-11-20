// EXEC: %compiler %enableEH %core_cmp_opt  %f -o %output
// EXEC-PIPE-0: %run %set_stdx_path %output | compare %f
// ASSERT: scan Done 100 iterations
// ASSERT: scan-not core dumped
// ASSERT: scan-not stack trace

import stdx.effect.{Command, Resumption}
import std.collection.*

class Eff <: Command<() -> Unit> {}

main() {
    let counter = Box(0)
    try {
        let a = perform Eff()
        a()
    } handle (e: Eff, r: Resumption<() -> Unit, Unit>) {
        println("handling")
        if (counter.value < 100) {
            counter.value += 1
            resume r with { =>
                let a = perform Eff()
                a()
            }
        } else {
            println("Returning")
        }
    }
    println("Done ${counter.value} iterations")
}
