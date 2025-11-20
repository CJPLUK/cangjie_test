// EXEC-PIPE-1: %compiler %enableEH %core_cmp_opt  %f -o %output 2>&1 | compare %f
// ASSERT: scan lambda capturing mutable variables needs to be called directly
// ASSERT: scan 2 errors generated, 2 errors printed
// ASSERT: scan-not core dumped
// ASSERT: scan-not stack trace


import stdx.effect.{Command, Resumption}

class Eff <: Command<Unit> {}

main() {
    var x: Int64 = 1
    try {
        x += 1
    } handle (e: Eff, res: Resumption<Unit, Unit>) {
        x += 1
        resume res
    }
}
