// Copyright (c) Huawei Technologies Co., Ltd. 2025. All rights reserved.
// This source file is part of the Cangjie project, licensed under Apache-2.0
// with Runtime Library Exception.
//
// See https://cangjie-lang.cn/pages/LICENSE for license information.

// Negative case: handing the Future to a call that survives inlining keeps the
// call as a user of it, so the fold is blocked. Folding here would hand a
// closure to a parameter typed Future and miscompile the call. Pairs with
// spawn_multi_optimized.cj, where an empty callee is inlined away before this
// pass runs and the same shape does fold.
//
// `foo` recurses so that a call to it survives into this pass. Note the
// inliner does NOT skip it wholesale: CheckCanRewrite only refuses when
// `callee == globalFunc` (a self-call inside foo's own body), so main's call
// site is a normal candidate and one level IS inlined -- at 15_FunctionInline
// main holds both the inlined `get()` and the recursive `Apply(foo)`. What
// reaches this pass is the recursive tail call: later const-propagation folds
// `n <= 0` to false and DCEs the inlined `get()` branch. The `scan-not` on
// `get` below pins that premise down, so this case cannot silently decay into
// a duplicate of spawn_tryget_not_optimized.cj.

// DEPENDENCE: ../pick_defination.py
// EXEC: %compiler %cmp_opt %enableO2 %dumpCHIRDebug -Woff unused %n.cj
// EXEC: %python pick_defination.py default_CHIR/[0-9]*_RedundantFutureOpt.chirtxt "Func @_CN7default6<main>Hv" | compare %f
// RUN-EXEC-PIPE-0: %run main
// ASSERT: scan-not executeClosure:
// ASSERT: scan-not @_CNat6FutureIG_E3getHv
// ASSERT: regex-begin %(?P<closure>\d+): \(\) -> Int64 = Lambda\[
// ASSERT: regex-after %(?P<future>\d+): Class-_CNat6FutureIG_E<Int64>& = Allocate\(Class-_CNat6FutureIG_E<Int64>\)
// ASSERT: regex-after %\d+: Void = Apply\(Class-_CNat6FutureIG_E<Int64>&->@_CNat6FutureIG_E6<init>HF0G_E, %(?P=future), %(?P=closure)\)
// ASSERT: regex-after %\d+: Class-_CNat6FutureIG_E<Int64>& = Spawn\(%(?P=future)\)
// ASSERT: regex-after %\d+: Int64 = Apply\(@_CN7default3fooHCNat6FutureIlEl, %(?P=future), %\d+\)

func foo(a: Future<Int64>, n: Int64): Int64 {
    if (n <= 0) {
        return a.get()
    }
    return foo(a, n - 1)
}

main(): Int64 {
    let f = spawn {
        => return 7
    }
    if (foo(f, 2) == 7) {
        return 0
    }
    return 1
}
