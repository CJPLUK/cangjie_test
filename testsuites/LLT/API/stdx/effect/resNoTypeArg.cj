// EXEC-PIPE-1: %compiler %enableEH %core_cmp_opt %f -o %output 2>&1 | compare %f
import stdx.effect.{Command, Resumption}

main() {
    try {
    } handle (_: Command<Int64>, _: Resumption) {}
}

// ASSERT: scan error
// ASSERT: scan the type of the resumption must extend 'effect.Resumption'
// ASSERT: scan 1 error generated, 1 error printed.
