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
class Mem <: Bar {
    init() {
        super()
    }
}

@ObjC
foreign class Foo {
    public prop a: ObjCPointer<Mem>
    public prop b: ObjCPointer<Float64>
    public prop c: ObjCPointer<Int64>
    public prop d: ObjCPointer<Bar>
    public prop e: ObjCPointer<ObjCPointer<Float64>>
    public prop f: ObjCPointer<ObjCPointer<Mem>>

    public mut prop aMut: ObjCPointer<Mem>
    public mut prop bMut: ObjCPointer<Float64>
    public mut prop cMut: ObjCPointer<Int64>
    public mut prop dMut: ObjCPointer<Bar>
    public mut prop eMut: ObjCPointer<ObjCPointer<Float64>>
    public mut prop fMut: ObjCPointer<ObjCPointer<Mem>>

    public static prop aStatic: ObjCPointer<Mem>
    public static prop bStatic: ObjCPointer<Float64>
    public static prop cStatic: ObjCPointer<Int64>
    public static prop dStatic: ObjCPointer<Bar>
    public static prop eStatic: ObjCPointer<ObjCPointer<Float64>>
    public static prop fStatic: ObjCPointer<ObjCPointer<Mem>>

    public static mut prop aStaticMut: ObjCPointer<Mem>
    public static mut prop bStaticMut: ObjCPointer<Float64>
    public static mut prop cStaticMut: ObjCPointer<Int64>
    public static mut prop dStaticMut: ObjCPointer<Bar>
    public static mut prop eStaticMut: ObjCPointer<ObjCPointer<Float64>>
    public static mut prop fStaticMut: ObjCPointer<ObjCPointer<Mem>>
}
