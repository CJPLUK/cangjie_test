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
    init()
}

@ObjC
public class Impl <: M {}

@ObjC
class A <: M {
    public init() {

    }

    public prop primitive: Int64 { 
        get() {
            0
        }
    }

    private var primitiveField: Int64 = 0
    public mut prop primitiveMut: Int64 {
        get() {
            primitiveField
        }
        set(value) {
            primitiveField = value
        }
    }

    public static prop primitiveStatic: Int64 {
        get() {
            0
        }
    }

    public static mut prop primitiveStaticMut: Int64 {
        get() {
            0
        }
        set(value) {

        }
    }

    public prop mirror: M {
        get() {
            M()
        }
    }

    private var mirrorField: M = M()
    public mut prop mirrorMut: M {
        get() {
            mirrorField
        }
        set(value) {
            mirrorField = value
        }
    }

    public static prop mirrorStatic: M {
        get() {
            M()
        }
    }

    public static mut prop mirrorStaticMut: M {
        get() {
            M()
        }
        set(value) {
            
        }
    }

    public prop mirrorSelf: M {
        get() {
            this
        }
    }

    public prop implSelf: A {
        get() {
            this
        }
    }

    public prop impl: A {
        get() {
            throw Exception("Can't call impl constructor")
        }
    }

    public static prop implStatic: A {
        get() {
            throw Exception("Can't call impl constructor")
        }
    }

    private static var implField: ?A = None
    public mut prop implMut: A {
        get() {
            implField ?? throw Exception("impl was not set")
        }
        set(value) {
            implField = value
        }
    }

    public static mut prop implStaticMut: A {
        get() {
            throw Exception("Can't call impl constructor")
        }
        set(value) {
            
        }
    }
}
