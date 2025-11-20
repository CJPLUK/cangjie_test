// EXEC: %compiler %enableEH %core_cmp_opt  %f -o %output
// EXEC-PIPE-0: %run %set_stdx_path %output | compare %f
// ASSERT: scan-not core dumped
// ASSERT: scan-not stack trace

import stdx.effect.{Command, Resumption}

class Eff <: Command<Unit> {}

main() {
    try {
        perform Eff()
        1
    } catch (e: Exception) {
        2
    } handle (_: Command<String>, next: Resumption<String, Int64>) {
        3
    } handle (_: Command<Unit> ) {
        0
    }
}
