// Copyright (c) Huawei Technologies Co., Ltd. 2025. All rights reserved.
// This source file is part of the Cangjie project, licensed under Apache-2.0
// with Runtime Library Exception.
//
// See https://cangjie-lang.cn/pages/LICENSE for license information.

// Several independent spawns in one function: the pass visits every Spawn, so
// each one must be rewritten on its own. Each Spawn is pinned to its own
// captured lambda, which is what stops one rewritten Spawn from satisfying
// every assert.
//
// `b` still folds despite being handed to `foo`: FunctionInline runs before
// RedundantFutureOpt, and `foo` is empty, so the call is inlined away and no
// longer counts as a user of the Future by the time the pass looks at it. A
// call that survives inlining *does* block the fold -- see
// spawn_arg_not_optimized.cj.

// DEPENDENCE: ../pick_defination.py
// EXEC: %compiler %cmp_opt %enableO2 %dumpCHIRDebug -Woff unused %n.cj
// EXEC: %python pick_defination.py default_CHIR/[0-9]*_RedundantFutureOpt.chirtxt "Func @_CN7default6<main>Hv" | compare %f
// RUN-EXEC-PIPE-0: %run main
// ASSERT: scan-not Allocate(Class-_CNat6FutureIG_E<Int64>)
// ASSERT: scan-not @_CNat6FutureIG_E6<init>
// ASSERT: regex-3 executeClosure: @_CNat6FutureIG_E14executeClosureHF0G_E
// ASSERT: regex-begin %(?P<c1>\d+): \(\) -> Int64 = Lambda\[
// ASSERT: regex-after %\d+: Class-_CNat6FutureIG_E<Int64>& = Spawn\(%(?P=c1)\).*executeClosure:
// ASSERT: regex-after %(?P<c2>\d+): \(\) -> Int64 = Lambda\[
// ASSERT: regex-after %\d+: Class-_CNat6FutureIG_E<Int64>& = Spawn\(%(?P=c2)\).*executeClosure:
// ASSERT: regex-after %(?P<c3>\d+): \(\) -> Int64 = Lambda\[
// ASSERT: regex-after %\d+: Class-_CNat6FutureIG_E<Int64>& = Spawn\(%(?P=c3)\).*executeClosure:

func foo(a: Future<Int64>): Unit {}

main(): Unit {
    let a = spawn {
        => return 1000
    }
    let b = spawn {
        => return 2000
    }
    spawn {
        => return 3000
    }
    foo(b)
}
