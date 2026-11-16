// Copyright (c) Huawei Technologies Co., Ltd. 2025. All rights reserved.
// This source file is part of the Cangjie project, licensed under Apache-2.0
// with Runtime Library Exception.
//
// See https://cangjie-lang.cn/pages/LICENSE for license information.

// (CJNATIVE and not Windows) EXEC-PIPE-1: %compiler %cmp_opt %f -o %output %compile_shared_lib_opt %import_objc_interop 2>& 1 | compare %f
// ASSERT: scan error: @ForeignGetterName requires exactly one 'String' literal argument
// ASSERT: scan error: @ForeignSetterName requires exactly one 'String' literal argument

import objc.lang.*

@ObjC
public open foreign class M {
    @ForeignGetterName["assignAbc:", "another"]
    public prop a: Int32

    @ForeignSetterName[name: "something"]
    public prop b: Float64
}
