// Copyright (c) Huawei Technologies Co., Ltd. 2025. All rights reserved.
// This source file is part of the Cangjie project, licensed under Apache-2.0
// with Runtime Library Exception.
//
// See https://cangjie-lang.cn/pages/LICENSE for license information.

// Binding the Future to a variable adds a third user, the Debug expression
// that keeps the variable observable. Three users still fold: the pass drops
// the Debug from the user set and optimises anyway. Unlike Allocate and Apply
// the Debug is kept, retargeted onto the lambda, so `a` stays in the dump.
// Asserting Debug takes the same captured value as Spawn is what proves the
// retarget happened rather than the Debug being left on a dead Future.

// DEPENDENCE: ../pick_defination.py
// EXEC: %compiler %cmp_opt %enableO2 %dumpCHIRDebug -Woff unused %n.cj
// EXEC: %python pick_defination.py default_CHIR/[0-9]*_RedundantFutureOpt.chirtxt "Func @_CN7default6<main>Hv" | compare %f
// RUN-EXEC-PIPE-0: %run main
// ASSERT: scan-not Allocate(Class-_CNat6FutureIG_E<Int64>)
// ASSERT: scan-not @_CNat6FutureIG_E6<init>
// ASSERT: regex-begin %(?P<closure>\d+): \(\) -> Int64 = Lambda\[
// ASSERT: regex-after %\d+: Class-_CNat6FutureIG_E<Int64>& = Spawn\(%(?P=closure)\).*executeClosure: @_CNat6FutureIG_E14executeClosureHF0G_E
// ASSERT: regex-after %\d+: Unit = Debug\(%(?P=closure), a\)

let N = 10000

main(): Unit {
    let a = spawn {
        => return 1 + N
    }
}
