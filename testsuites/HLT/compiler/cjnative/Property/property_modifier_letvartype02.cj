/*
 * Copyright (c) Huawei Technologies Co., Ltd. 2025. All rights reserved.
 * This source file is part of the Cangjie project, licensed under Apache-2.0
 * with Runtime Library Exception.
 * 
 * See https://cangjie-lang.cn/pages/LICENSE for license information.
 */

// LEVEL: 0
// EXEC-PIPE-1: %compiler %cmp_opt %f -o %output 2>&1 | compare %f

class P {}

class S {}

open class A {
    public open prop i1: P {
        get() {
            return P()
        }
    }
    public static prop i2: P {
        get() {
            return P()
        }
    }
}

class B <: A {
    public mut override prop i1: P {
        get() {
            return P()
        }
    }
    /*
    redef static mut prop i2: P {
        get() {return P()}
    }
     */
}

class C <: A {
    public override prop i1: S {
        get() {
            return S()
        }
    }
}

main(): Int64 {
    A();
    B();
    C()
    return 0
}
// ASSERT: scan sema_inherit_member_type_inconsistent
// ASSERT: scan sema_missing_overridden_func
// ASSERT: scan sema_property_have_same_declaration_in_inherit_immut
// ASSERT: scan sema_prop_redefinition
