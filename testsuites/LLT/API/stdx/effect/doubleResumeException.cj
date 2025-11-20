// EXEC: %compiler %enableEH %core_cmp_opt  %f -o %output
// RUN-EXEC-PIPE-0: %run %set_stdx_path %output | compare %f
// ASSERT: scan Pre resume
// ASSERT: scan Post resume
// ASSERT: scan DoubleResumeException: Resumption resumed multiple times
// ASSERT: scan Post catch
// ASSERT: scan-not core dumped
// ASSERT: scan-not stack trace


import stdx.effect.{Command, Resumption, DoubleResumeException}

class Get <: Command<Unit> {}

main() {
    let result: Box<Option<Resumption<Unit, Unit>>> = Box(None)

    try {
        perform Get()
    } handle (_: Get, next: Resumption<Unit, Unit>) {
        result.value = next
    }
    println("Pre resume")
    resume result.value.getOrThrow()
    println("Post resume")
    try {
        resume result.value.getOrThrow()
    } catch (e: DoubleResumeException) {
        println(e)
    }
    println("Post catch")
    ()
}
