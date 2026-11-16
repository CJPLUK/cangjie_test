// Copyright (c) Huawei Technologies Co., Ltd. 2025. All rights reserved.
// This source file is part of the Cangjie project, licensed under Apache-2.0
// with Runtime Library Exception.
//
// See https://cangjie-lang.cn/pages/LICENSE for license information.

// (CJNATIVE and not Windows) EXEC-PIPE-1: %compiler %cmp_opt %f -o %output %compile_shared_lib_opt %import_objc_interop 2>& 1 | compare %f
// ASSERT: scan-16 error: type of member property in '@ObjC' foreign declaration must be Objective-C compatible
// ASSERT: scan 16 errors generated, 16 errors printed

package cjworld

import objc.lang.*

class A {}

@ObjC
foreign class Foo {
    public prop a: String
    public prop b: Array<Int64>
    public prop c: A
    public prop d: Unit

    public mut prop aMut: String
    public mut prop bMut: Array<Int64>
    public mut prop cMut: A
    public mut prop dMut: Unit

    public static prop aStatic: String
    public static prop bStatic: Array<Int64>
    public static prop cStatic: A
    public static prop dStatic: Unit

    public static mut prop aStaticMut: String
    public static mut prop bStaticMut: Array<Int64>
    public static mut prop cStaticMut: A
    public static mut prop dStaticMut: Unit
}
