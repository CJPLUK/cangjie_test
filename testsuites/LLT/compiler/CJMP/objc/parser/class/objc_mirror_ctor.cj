// Copyright (c) Huawei Technologies Co., Ltd. 2025. All rights reserved.
// This source file is part of the Cangjie project, licensed under Apache-2.0
// with Runtime Library Exception.
//
// See https://cangjie-lang.cn/pages/LICENSE for license information.

// (CJNATIVE and not Windows) EXEC-PIPE-0: %frontendCompiler %cmp_opt %compile_shared_lib_opt %f -o %output

import objc.lang.*

@ObjC
foreign class M {
    init()
    @ForeignName["initWithA:"]
    init(a: Int64)
    @ForeignName["initWithA:andB:"]
    init(a: Int64, b: Bool)
}
