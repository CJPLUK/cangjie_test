/*
 * Copyright (c) Huawei Technologies Co., Ltd. 2025. All rights reserved.
 * This source file is part of the Cangjie project, licensed under Apache-2.0
 * with Runtime Library Exception.
 * 
 * See https://cangjie-lang.cn/pages/LICENSE for license information.
 */

// LEVEL: 1
// EXEC-PIPE-1: %compiler %cmp_opt %f -o %output 2>&1 | compare %f

enum A {
    a

    public prop c: Int64 {
        get() {
            0
        }
        set(v) {}
    }
}

main(): Int64 {
    var i = A.a
    i.c = [1]
    return i.c
}
// ASSERT: scan sema_immutable_property_with_setter
// ASSERT: scan sema_cannot_assign_to_immutable
