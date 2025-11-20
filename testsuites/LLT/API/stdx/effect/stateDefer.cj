// EXEC: %compiler %enableEH %core_cmp_opt  %f -o %output
// EXEC-PIPE-0: %run %set_stdx_path %output | compare %f
// ASSERT: scan Counter is 10
// ASSERT: scan Counter is 9
// ASSERT: scan Counter is 8
// ASSERT: scan Counter is 7
// ASSERT: scan Counter is 6
// ASSERT: scan Counter is 5
// ASSERT: scan Counter is 4
// ASSERT: scan Counter is 3
// ASSERT: scan Counter is 2
// ASSERT: scan Counter is 1
// ASSERT: scan-not core dumped
// ASSERT: scan-not stack trace


import stdx.effect.{Command, Resumption}

class Get <: Command<Int64> {}
class Put <: Command<Unit> {
    Put(let value: Int64) {}
}

func get() { perform Get() }
func put(value: Int64) { perform Put(value) }

main() {
    let counter = Box(10)

    try {
        while (true) {
            let counter = get()
            if (counter <= 0) { break }
            println("Counter is ${counter}")
            put(counter - 1)
        }
    } handle (_: Get, next: Resumption<Int64, Unit>) {
        resume next with counter.value
    } handle (p: Put, next: Resumption<Unit, Unit>) {
        counter.value = p.value
        resume next
    }
}
