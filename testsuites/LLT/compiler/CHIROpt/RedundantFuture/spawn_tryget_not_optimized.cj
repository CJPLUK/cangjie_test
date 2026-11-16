// Copyright (c) Huawei Technologies Co., Ltd. 2025. All rights reserved.
// This source file is part of the Cangjie project, licensed under Apache-2.0
// with Runtime Library Exception.
//
// See https://cangjie-lang.cn/pages/LICENSE for license information.

// Negative case: `tryGet()` reads the Future, so it is a real fourth user and
// CheckSpawnWithFuture bails out -- only Debug and Spawn are erased from the
// user set, leaving two entries where the fold needs exactly one. Allocate,
// <init> and the tryGet call all survive and Spawn still takes the Future.
// Asserting Spawn's operand is the allocated Future rather than the lambda is
// what distinguishes "not optimised" from "partially optimised".

// DEPENDENCE: ../pick_defination.py
// EXEC: %compiler %cmp_opt %enableO2 %dumpCHIRDebug -Woff unused %n.cj
// EXEC: %python pick_defination.py default_CHIR/[0-9]*_RedundantFutureOpt.chirtxt "Func @_CN7default6<main>Hv" | compare %f
// RUN-EXEC-PIPE-0: %run main
// ASSERT: scan-not executeClosure:
// ASSERT: regex-begin %(?P<closure>\d+): \(\) -> Int64 = Lambda\[
// ASSERT: regex-after %(?P<future>\d+): Class-_CNat6FutureIG_E<Int64>& = Allocate\(Class-_CNat6FutureIG_E<Int64>\)
// ASSERT: regex-after %\d+: Void = Apply\(Class-_CNat6FutureIG_E<Int64>&->@_CNat6FutureIG_E6<init>HF0G_E, %(?P=future), %(?P=closure)\)
// ASSERT: regex-after %\d+: Class-_CNat6FutureIG_E<Int64>& = Spawn\(%(?P=future)\)
// ASSERT: regex-after %\d+: Unit = Debug\(%(?P=future), f\)
// ASSERT: regex-after @_CNat6FutureIG_E6tryGetHv, %(?P=future)\)

main(): Int64 {
    let f = spawn {
        => return 7
    }
    match (f.tryGet()) {
        case Some(v) => v - 7
        case None => 0
    }
}
