// EXEC: %compiler %enableEH %core_cmp_opt  %f -o %output
// EXEC-PIPE-0: %run %set_stdx_path %output | compare %f
// ASSERT: scan Ping
// ASSERT: scan Pong
// ASSERT: scan Ping
// ASSERT: scan Pong
// ASSERT: scan-not core dumped
// ASSERT: scan-not stack trace

import stdx.effect.{Command, Resumption}

class Yield <: Command<Unit> {}

public func roundRobin(t: () -> Unit, u: () -> Unit): Unit {
    try {
        t ()
    } handle (_: Yield, rt: Resumption<Unit, Unit>) {
        roundRobin(u, {=> resume rt})
    }
}

func ping() {
    println ("Ping")
    perform Yield()
    println ("Ping")
    perform Yield()
}

func pong() {
    println ("Pong")
    perform Yield()
    println ("Pong")
    perform Yield()
}

main() {
    roundRobin(ping, pong)
    0
}