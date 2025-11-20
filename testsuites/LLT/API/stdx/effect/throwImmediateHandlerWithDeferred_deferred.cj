// EXEC: %compiler %enableEH %core_cmp_opt  %f -o %output
// EXEC-PIPE-0: %run %set_stdx_path %output | compare %f
// ASSERT: scan Hello
// ASSERT: scan-not core dumped
// ASSERT: scan-not stack trace

import stdx.effect.{Command, Resumption}

class Get <: Command<Int64> {}
class Eff <: Command<Int64> {}

main() {
    try {
        try {
            perform Get()
        } handle(_: Eff, next: Resumption<Int64, Int64>) {
            2
        } handle (_: Get) {
            throw Exception("Hello")
        }
    } catch (e: Exception) {
        println(e.message)
    }
    0
}
