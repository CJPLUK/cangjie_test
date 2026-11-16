// Copyright (c) Huawei Technologies Co., Ltd. 2025. All rights reserved.
// This source file is part of the Cangjie project, licensed under Apache-2.0
// with Runtime Library Exception.
//
// See https://cangjie-lang.cn/pages/LICENSE for license information.

// Baseline case: a `spawn` whose Future is never read has exactly two users
// (the Apply running <init> and the Spawn itself), so the Future is redundant.
// Allocate and Apply are plain expressions here, so they are simply erased and
// Spawn takes the closure directly, gaining an executeClosure reference.
// The asserts walk the function top to bottom, one step per assert, with the
// captured lambda carried forward so Spawn is pinned to that very value.

// DEPENDENCE: ../pick_defination.py
// EXEC: %compiler %cmp_opt %enableO2 %dumpCHIRDebug -Woff unused %n.cj
// EXEC: %python pick_defination.py default_CHIR/[0-9]*_RedundantFutureOpt.chirtxt "Func @_CN7default6<main>Hv" | compare %f
// RUN-EXEC-PIPE-0: %run main
// ASSERT: scan-not Allocate(Class-_CNat6FutureIG_E<Int64>)
// ASSERT: scan-not @_CNat6FutureIG_E6<init>
// ASSERT: regex-begin %(?P<closure>\d+): \(\) -> Int64 = Lambda\[
// ASSERT: regex-after %\d+: Class-_CNat6FutureIG_E<Int64>& = Spawn\(%(?P=closure)\).*executeClosure: @_CNat6FutureIG_E14executeClosureHF0G_E

let N = 10000

main(): Unit {
    spawn {
        => return 1 + N
    }
}
