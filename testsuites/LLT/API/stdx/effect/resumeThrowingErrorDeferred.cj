// EXEC: %compiler %enableEH %core_cmp_opt  %f -o %output
// EXEC-PIPE-0: %run %set_stdx_path %output | compare %f
// ASSERT: scan Hello
// ASSERT: scan-not Never
// ASSERT: scan-not core dumped
// ASSERT: scan-not stack trace


import stdx.effect.{Command, Resumption}

class Get <: Command<String> {}

func stackOverFlow(): Int64 {
    stackOverFlow() + 1
}

main() {
    try {
        try {
            try {
                println(perform Get())
            } catch (e: Error) {
                println("Hello")
            }
        } handle (_: Get, next: Resumption<String, Unit>) {
            try {
                stackOverFlow()
                ()
            } catch (e: Error) {
                resume next throwing e
                ()
            }
        }
    } catch (_: Error) {
        println("Never")
    }
    0
}
