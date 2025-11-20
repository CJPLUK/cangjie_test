// EXEC: %compiler %enableEH %core_cmp_opt  %f -o %output
// EXEC-PIPE-0: %run %set_stdx_path %output | compare %f
// ASSERT: scan 1
// ASSERT: scan 2
// ASSERT: scan 3
// ASSERT: scan-not core dumped
// ASSERT: scan-not stack trace

import stdx.effect.{Command, Resumption}

class Eff <: Command<Unit> {}

main() {

    try {
        println("1")
        perform Eff()
        println("2")
    } handle (_: Eff, next: Resumption<Unit, Unit>) {
        try {
            resume next
            println("3")
        } handle (_: Eff, next2: Resumption<Unit, Unit>) {
            println("never")
            resume next2
        }

    }

    0
}
