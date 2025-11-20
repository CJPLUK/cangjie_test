// EXEC: %compiler %enableEH %core_cmp_opt  %f -o %output
// EXEC-PIPE-0: %run %set_stdx_path %output | compare %f
// ASSERT: scan-not core dumped
// ASSERT: scan-not stack trace

import stdx.effect.{Command, Resumption}

main() {
    try {
        ()
    } handle (cmd: Command<Unit>, next: Resumption<Unit, Unit>) {
        resume next
    }
    ()
}
