// Copyright (c) Huawei Technologies Co., Ltd. 2025. All rights reserved.
// This source file is part of the Cangjie project, licensed under Apache-2.0
// with Runtime Library Exception.
//
// See https://cangjie-lang.cn/pages/LICENSE for license information.

// (CJNATIVE and not Windows) EXEC-PIPE-0: %compiler %cmp_opt %f -o %output %compile_shared_lib_opt %import_objc_interop 2>& 1 | compare %f
// ASSERT: scan-not error

import objc.lang.*

class PureCangjie {}

@ObjC
public open foreign class M {
    init()
}

@ObjC
class L <: M {
    init() {
        super()
    }

    private func foo(k: PureCangjie) {}

    private func foo(k: PureCangjie, kk: PureCangjie) {}
    private func fooo(k: PureCangjie): PureCangjie {
        return k
    }

    private func foo(a: ?L): M {
        return a ?? M()
    }
    private func foo(a: ?L, kk: PureCangjie) {}

    private func foooo(k: PureCangjie): M {
        return M()
    }

    private static func foostatic(k: PureCangjie) {}
}
