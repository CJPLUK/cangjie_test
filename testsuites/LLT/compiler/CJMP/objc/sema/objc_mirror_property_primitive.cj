// Copyright (c) Huawei Technologies Co., Ltd. 2025. All rights reserved.
// This source file is part of the Cangjie project, licensed under Apache-2.0
// with Runtime Library Exception.
//
// See https://cangjie-lang.cn/pages/LICENSE for license information.

// (CJNATIVE and not Windows) EXEC-PIPE-0: %compiler %cmp_opt %f -o %output %compile_shared_lib_opt %import_objc_interop 2>& 1 | compare %f
// ASSERT: scan-not error

package cjworld

import objc.lang.*

type PrimitiveType = Int32

@ObjC
foreign class Foo {
    public prop a: Int64
    public prop b: Float64
    public prop c: Int8
    public prop d: PrimitiveType

    public static prop aStatic: Int64
    public static prop bStatic: Float64
    public static prop cStatic: Int8
    public static prop dStatic: PrimitiveType

    public mut prop aMut: Int64
    public mut prop bMut: Float64
    public mut prop cMut: Int8
    public mut prop dMut: PrimitiveType

    public static mut prop aStaticMut: Int64
    public static mut prop bStaticMut: Float64
    public static mut prop cStaticMut: Int8
    public static mut prop dStaticMut: PrimitiveType
}
