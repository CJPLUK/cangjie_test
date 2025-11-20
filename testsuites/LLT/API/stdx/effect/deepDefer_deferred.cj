// EXEC: %compiler %enableEH %core_cmp_opt  %f -o %output
// EXEC-PIPE-0: %run %set_stdx_path %output | compare %f
// ASSERT: scan je
// ASSERT: scan-not core dumped
// ASSERT: scan-not stack trace
import stdx.effect.*
import std.convert.*

class Get <: Command<String> {}
class Set <: Command<String> {}

main(args: Array<String>) {
    let number = Box<Int64>(100)
    try {
        try {
            println(perform Get())
        } handle (_: Set, next: Resumption<String, Unit>) {
            resume next with "ja"
        }
        12
    } handle(_: Get, next: Resumption<String, Int64>){
        resume next with "je"
    }
    0
}
