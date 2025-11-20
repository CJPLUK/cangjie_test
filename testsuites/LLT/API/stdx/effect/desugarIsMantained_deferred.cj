// EXEC: %compiler %enableEH %core_cmp_opt  %f -o %output
// EXEC-PIPE-0: %run %set_stdx_path %output | compare %f
// ASSERT: scan-not core dumped
// ASSERT: scan-not stack trace

import stdx.effect.{Command, Resumption}

class Cont {
    public prop value: Int64 {
        get() {
            40
        }
    }
}

class Eff <: Command<() -> Int64> {
    Eff(let f: () -> Int64) {}
}

class MyExc <: Exception {
    MyExc(let f: () -> Int64) {}
}

main() {
    let c = Cont()
    try {
        perform Eff { c.value + 2 }
        13
    } handle (e: Eff) {
        resume with { => c.value }
        14
    } handle (e: Eff) {
        resume throwing MyExc { c.value }
        15
    } handle (e: Eff, next: Resumption<() -> Int64, Int64>) {
        resume next with { => c.value }
        16
    }
    0
}
