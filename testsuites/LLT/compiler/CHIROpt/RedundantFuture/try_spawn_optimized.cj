// Copyright (c) Huawei Technologies Co., Ltd. 2025. All rights reserved.
// This source file is part of the Cangjie project, licensed under Apache-2.0
// with Runtime Library Exception.
//
// See https://cangjie-lang.cn/pages/LICENSE for license information.

// A `spawn` inside a `try` block lowers to TrySpawn / TryApply / TryAllocate.
// The redundant Future must be removed here too: TrySpawn takes the closure
// directly (gaining an executeClosure reference), while the TryAllocate and
// TryApply terminators are replaced by a GoTo to their own success block so
// every block keeps a terminator.

// DEPENDENCE: ../pick_defination.py
// EXEC: %compiler %cmp_opt %enableO2 %dumpCHIRDebug -Woff unused %n.cj
// EXEC: %python pick_defination.py default_CHIR/[0-9]*_RedundantFutureOpt.chirtxt "Func @_CN7default6<main>Hv" | compare %f
// RUN-EXEC-PIPE-0: %run main
// ASSERT: scan-not TryAllocate
// ASSERT: scan-not TryApply
// ASSERT: scan-not @_CNat6FutureIG_E6<init>
// ASSERT: regex-begin %(?P<closure>\d+): \(\) -> Int64 = Lambda\[
// ASSERT: regex-after ^\s*GoTo\(#(?P<initBlk>\d+)\)
// ASSERT: regex-after ^Block #(?P=initBlk):\s+// predecessors: \[#0\]$
// ASSERT: regex-after ^\s*GoTo\(#(?P<spawnBlk>\d+)\)
// ASSERT: regex-after ^Block #(?P=spawnBlk):\s+// predecessors: \[#(?P=initBlk)\]$
// ASSERT: regex-after %\d+: Class-_CNat6FutureIG_E<Int64>& = TrySpawn\(%(?P=closure), normal: #\d+, exception: #\d+\).*executeClosure: @_CNat6FutureIG_E14executeClosureHF0G_E

main(): Int64 {
    try {
        spawn {
            => return 1
        }
    } catch (e: Exception) {
        println("caught")
        return 1
    }
    return 0
}
