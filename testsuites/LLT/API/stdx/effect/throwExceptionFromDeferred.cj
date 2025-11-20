// EXEC: %compiler %enableEH %core_cmp_opt  %f -o %output
// EXEC-PIPE-0: %run %set_stdx_path %output | compare %f
// ASSERT: scan-not core dumped
// ASSERT: scan-not stack trace

import stdx.effect.*

class Deferred <: Command<Unit> {}
class Immediate <: Command<Unit> {}

class MyException <: Exception {}

main() {
    try {
        try {
            let x = try {
                perform Immediate()
                34
            } handle (_: Deferred, res: Resumption<Unit, Int64>) {
                42
            }
            33
        } handle (_: Immediate) {
            throw MyException()
            43
        }
    } catch(_: MyException) {
        return 0
    }
}
