// DEPENDENCE: effect_in_macro_define.cj
// EXEC: %compiler %cmp_macro effect_in_macro_define.cj
// EXEC: %run_macro %compiler %enableEH %cmp_opt %macro_lib %f -o %output
// EXEC: %run %set_stdx_path %run_opt %output %run_args 2>&1 | compare %f
import stdx.effect.{Command, Resumption}


import AAA.*

class Eff <: Command<String> {}

@NN
main() {
    try {
        perform Eff()
        ()
    } handle (c: Command<String>, r: Resumption<String, Unit>) {
        resume r with "Hello, World!"
        ()
    }
}

// ASSERT: regex-not core dumped
// ASSERT: regex-not stack trace
