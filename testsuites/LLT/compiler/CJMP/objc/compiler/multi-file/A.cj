// Copyright (c) Huawei Technologies Co., Ltd. 2025. All rights reserved.
// This source file is part of the Cangjie project, licensed under Apache-2.0
// with Runtime Library Exception.
//
// See https://cangjie-lang.cn/pages/LICENSE for license information.

// (CJNATIVE and not Windows) DEPENDENCE: ./M.cj
// (CJNATIVE and not Windows) EXEC-PIPE-0: %compiler %cmp_opt %f M.cj -o %output %compile_shared_lib_opt %import_objc_interop 2>& 1 | compare %f

// ASSERT: scan-not error

package cjworld

import objc.lang.*

@ObjC
class A <: M {
    init() {
        super()
    }
}
