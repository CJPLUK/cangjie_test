// EXEC: %compiler %enableEH %core_cmp_opt  %f -o %output
// EXEC-PIPE-0: %run %set_stdx_path %output | compare %f
// ASSERT: scan-not Unreachable
// ASSERT: scan-not core dumped
// ASSERT: scan-not stack trace

import stdx.effect.{Command, Resumption}

class Eff <: Command<Unit> {}

main() {
    try {
        perform Eff()
        println("Unreachable")
    } handle (e: Eff, res: Resumption<Unit, Unit>) {
    }
}
