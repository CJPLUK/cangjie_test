// EXEC: %compiler %enableEH %core_cmp_opt  %f -o %output
// EXEC-PIPE-0: %run %set_stdx_path %output | compare %f
// ASSERT: scan-not core dumped
// ASSERT: scan-not stack trace

import stdx.effect.{Command, Resumption}

class Eff <: Command<Int64> { Eff() {} }

main() {
    try {
        let lam = { => let x = 1 + 1 }
        perform Eff()
        ()
    } handle (eff: Eff, r: Resumption<Int64, Unit>) {
        ()
    }
}
