// EXEC: %compiler %enableEH %core_cmp_opt  %f -o %output
// EXEC-PIPE-0: %run %set_stdx_path %output | compare %f
// ASSERT: scan The value is 42
// ASSERT: scan-not core dumped
// ASSERT: scan-not stack trace


import stdx.effect.{Command, Resumption}

class Get <: Command<Int64> {}

func readGlobal() {
    println("The value is ${perform Get()}")
}

main() {
    let value = 42
    try {
        readGlobal()
    } handle (_: Get, next: Resumption<Int64, Unit>) {
        resume next with value
    }
    ()
}
