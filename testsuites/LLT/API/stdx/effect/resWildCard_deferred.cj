// EXEC: %compiler %enableEH %core_cmp_opt  %f -o %output
// EXEC-PIPE-0: %run %set_stdx_path %output | compare %f
// ASSERT: scan-not core dumped
// ASSERT: scan-not stack trace

import stdx.effect.{Command, Resumption}

class Eff <: Command<Int64> {}

main() {
    try {
        ()
    } handle (eff: Eff, next: Resumption<Int64, Unit>) {
        resume next with 10
    }
}
