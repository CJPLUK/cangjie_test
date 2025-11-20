// EXEC: %compiler %enableEH %core_cmp_opt  %f -o %output
// EXEC-PIPE-0: %run %set_stdx_path %output | compare %f
// ASSERT: scan Toplevel
// ASSERT: scan Nested
// ASSERT: scan-not core dumped
// ASSERT: scan-not stack trace

import stdx.effect.{Command, Resumption}

class Eff <: Command<Int64> {
    Eff() {}
}

main() {
    let x = try {
        perform Eff()
        try{
            perform Eff()
        } handle(e: Eff, next: Resumption<Int64, Int64>) {
            println("Nested")
            resume next with 0
        }
    } handle(e: Eff, next: Resumption<Int64, Int64>) {
        println("Toplevel")
        resume next with 0
    }
    0
}
