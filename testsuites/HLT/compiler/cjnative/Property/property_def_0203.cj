/*
 * Copyright (c) Huawei Technologies Co., Ltd. 2025. All rights reserved.
 * This source file is part of the Cangjie project, licensed under Apache-2.0
 * with Runtime Library Exception.
 * 
 * See https://cangjie-lang.cn/pages/LICENSE for license information.
 */

// LEVEL: 0
// EXEC-PIPE-1: %compiler %cmp_opt %f -o %output 2>&1 | compare %f

main(): Int64 {
    var a = Doo()
    return 0
}

interface Boo {
    mut prop m: Int32
    prop n: Int32
}

interface Coo <: Boo {
    mut prop n: Int32 {
        get() {
            return 1
        }
        set(input) {
            ()
        }
    }
    prop m: Int32
}

interface Eoo <: Boo {
    mut prop m: Int64 {
        get() {
            return 1
        }
        set(input) {
            ()
        }
    }
    prop n: Int64
}

class Doo <: Coo {
    public mut override prop m: Int32 {
        get() {
            return (10)
        }
        set(input) {
            ()
        }
    }
    public prop n: Int32 {
        get() {
            return 20
        }
    }
}
// ASSERT: scan sema_property_have_same_declaration_in_inherit_immut
// ASSERT: scan sema_property_have_same_declaration_in_inherit_mut
// ASSERT: scan sema_inherit_member_type_inconsistent
// ASSERT: scan sema_prop_redefinition
