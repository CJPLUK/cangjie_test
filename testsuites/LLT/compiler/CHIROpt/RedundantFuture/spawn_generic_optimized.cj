// Copyright (c) Huawei Technologies Co., Ltd. 2025. All rights reserved.
// This source file is part of the Cangjie project, licensed under Apache-2.0
// with Runtime Library Exception.
//
// See https://cangjie-lang.cn/pages/LICENSE for license information.

// A spawn written inside a generic method still folds after the instantiated
// body has been inlined into its caller: by the time this pass runs the Future
// is concrete, and the lambda keeps the mangled name of the instantiation it
// came from. The spawn captures the method's parameter, so the closure outlives
// the frame that created it -- the fold must not disturb that capture.

// DEPENDENCE: ../pick_defination.py
// EXEC: %compiler %cmp_opt %enableO2 %dumpCHIRDebug -Woff unused %n.cj
// EXEC: %python pick_defination.py default_CHIR/[0-9]*_RedundantFutureOpt.chirtxt "Func @_CN7default6<main>Hv" | compare %f
// RUN-EXEC-PIPE-0: %run main
// ASSERT: scan-not Allocate(Class-_CNat6FutureIG_E<Int64>)
// ASSERT: scan-not @_CNat6FutureIG_E6<init>
// ASSERT: regex-begin %(?P<closure>\d+): \(\) -> Int64 = Lambda\[_CN7default4testIlHlEL_E
// ASSERT: regex-after %\d+: Class-_CNat6FutureIG_E<Int64>& = Spawn\(%(?P=closure)\).*executeClosure: @_CNat6FutureIG_E14executeClosureHF0G_E

class A {
    public func test<T>(x: T): T {
        spawn { x }
        x
    }
}

main(): Int64 {
    return A().test(0)
}
