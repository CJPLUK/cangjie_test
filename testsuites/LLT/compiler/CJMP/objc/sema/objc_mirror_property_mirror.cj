// Copyright (c) Huawei Technologies Co., Ltd. 2025. All rights reserved.
// This source file is part of the Cangjie project, licensed under Apache-2.0
// with Runtime Library Exception.
//
// See https://cangjie-lang.cn/pages/LICENSE for license information.

// (CJNATIVE and not Windows) EXEC-PIPE-0: %compiler %cmp_opt %f -o %output %compile_shared_lib_opt %import_objc_interop 2>& 1 | compare %f
// ASSERT: scan-not error

package cjworld

import objc.lang.*

@ObjC
public open foreign class Bar {
    init()
}

@ObjC
foreign class Foo {
    public prop a: Bar

    public static prop aStatic: Bar

    public mut prop aMut: Bar

    public static mut prop aStaticMut: Bar
}
