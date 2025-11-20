// EXEC: %compiler %enableEH %core_cmp_opt  %f -o %output
// EXEC-PIPE-0: %run %set_stdx_path %output | compare %f
// ASSERT: scan-not core dumped
// ASSERT: scan-not stack trace

import stdx.effect.{Command, Resumption}
import std.collection.*

class Foo {
    Foo(public let x: Int64) {
        println("x = ${x}")
    }
    func print(): Unit {
        println("print function is called")
    }
}

class Eff <: Command<Foo> {
    Eff() {}
}

main() {
    try {
        let a = perform Eff()
        println("it is resumed")
        a.print()
    } handle(e: Eff, next: Resumption<Foo, Unit>) {
        println("it is performed")
        resume next with Foo(6)
    }
    0
}
