// Copyright (c) Huawei Technologies Co., Ltd. 2025. All rights reserved.
// This source file is part of the Cangjie project, licensed under Apache-2.0
// with Runtime Library Exception.
//
// See https://cangjie-lang.cn/pages/LICENSE for license information.

// (CJNATIVE and not Windows) EXEC-PIPE-0: %compiler %cmp_opt %f -o %output %compile_shared_lib_opt %import_objc_interop 2>& 1 | compare %f
// ASSERT: scan-not error

import objc.lang.*

@ObjC
public open foreign class M {
    @ForeignGetterName["getA"]
    @ForeignSetterName["assignA:"]
    public mut prop a: Int32

    @ForeignSetterName["assignB:"]
    public mut prop b: Int32

    @ForeignGetterName["getC"]
    public prop c: Int32

    @ForeignName["_d"]
    @ForeignSetterName["assignD:"]
    public mut prop d: Int32

    @ForeignName["_e"]
    @ForeignGetterName["retrieveE"]
    @ForeignSetterName["putE:"]
    public mut prop e: Int32
}
