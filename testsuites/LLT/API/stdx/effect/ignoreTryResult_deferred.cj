// EXEC: %compiler %enableEH %core_cmp_opt  %f -o %output
// EXEC-PIPE-0: %run %set_stdx_path %output | compare %f
// ASSERT: scan-not core dumped
// ASSERT: scan-not stack trace

import stdx.effect.{Command, Resumption}
import std.collection.*

class Eff <: Command<Int64> {}

main() {
    try {
        try {
            1
        } handle (e: Eff, next: Resumption<Int64, Int64>) {
            2
        }
    } handle(e: Eff, next: Resumption<Int64, Int64>) {
        3
    }
    0
}
