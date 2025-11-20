// EXEC: %compiler %enableEH %core_cmp_opt  %f -o %output
// EXEC-PIPE-0: %run %set_stdx_path %output | compare %f
// ASSERT: scan Caught exception
// ASSERT: scan-not core dumped
// ASSERT: scan-not stack trace

import stdx.effect.{Command, Resumption}

class Eff <: Command<Unit> {}

main() {
    try {
        perform Eff()
        throw Exception()
    } catch (e: Exception) {
        println("Caught exception")
    } handle (_: Command<Unit>, next: Resumption<Unit, Unit>) {
        resume next
    }
    ()
}
