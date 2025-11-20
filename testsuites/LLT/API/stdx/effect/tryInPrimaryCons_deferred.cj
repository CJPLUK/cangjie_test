// EXEC: %compiler %enableEH %core_cmp_opt  %f -o %output
// EXEC-PIPE-0: %run %set_stdx_path %output | compare %f
// ASSERT: scan Handling Eff
// ASSERT: scan-not core dumped
// ASSERT: scan-not stack trace

import stdx.effect.{Command, Resumption}

class Eff <: Command<Unit> {}

class Test {

    Test(fn: () -> Unit) {
        try {
            fn()
        } handle (new: Eff, next: Resumption<Unit, Unit>) {
            println("Handling Eff")
            resume next
        }
    }
}

main() {
    Test({=> perform Eff()})
    ()
}
