// Copyright (c) Huawei Technologies Co., Ltd. 2025. All rights reserved.
// This source file is part of the Cangjie project, licensed under Apache-2.0
// with Runtime Library Exception.
//
// See https://cangjie-lang.cn/pages/LICENSE for license information.

// (CJNATIVE and not Windows) EXEC-PIPE-0: %frontendCompiler %dump-parse %cmp_opt %f -o %output %compile_shared_lib_opt

import objc.lang.*

@ObjC
public open foreign class N {
    public open func foo(): Unit
    public open func bar(): Bool
}

@ObjC
public open foreign class M <: N {
    init()

    public override func bar(): Bool
}

@ObjC
class L <: M {
    init() {
        super()
    }

    public override func foo() {}
}
