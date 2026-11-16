/*
 * Copyright (c) Huawei Technologies Co., Ltd. 2025. All rights reserved.
 * This source file is part of the Cangjie project, licensed under Apache-2.0
 * with Runtime Library Exception.
 * 
 * See https://cangjie-lang.cn/pages/LICENSE for license information.
 */

// LEVEL: 0
// EXEC-PIPE-1: %compiler %cmp_opt %f -o %output 2>&1 | compare %f

interface A {
    mut prop a: Int64
}

abstract class B <: A {
    public prop a: Int32 {
        get() {
            0
        }
    }
}

main(): Int64 {
    return 0
}
// ASSERT: scan sema_inherit_member_type_inconsistent
// ASSERT: scan sema_prop_redefinition
