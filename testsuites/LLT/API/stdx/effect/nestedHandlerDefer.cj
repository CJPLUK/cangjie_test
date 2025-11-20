// EXEC: %compiler %enableEH %core_cmp_opt  %f -o %output
// EXEC-PIPE-0: %run %set_stdx_path %output | compare %f
// ASSERT: scan Handling Eff
// ASSERT: scan Handling Eff1
// ASSERT: scan Handling Eff
// ASSERT: scan-not core dumped
// ASSERT: scan-not stack trace

import stdx.effect.{Command, Resumption}
import std.collection.*

class Eff <: Command<Int64> {}
class Eff1 <: Command<Int64> {}

main() {
    let _ = try {
        perform Eff()
        try{
            perform Eff1()
        } handle(e: Eff1, next: Resumption<Int64, Int64>) {
            println("Handling Eff1")
            resume next with perform Eff()
        }
    } handle(e: Eff, next: Resumption<Int64, Int64>) {
        println("Handling Eff")
        resume next with 6
    }
    0
}
