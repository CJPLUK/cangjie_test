/*
 * Copyright (c) Huawei Technologies Co., Ltd. 2025. All rights reserved.
 * This source file is part of the Cangjie project, licensed under Apache-2.0
 * with Runtime Library Exception.
 * 
 * See https://cangjie-lang.cn/pages/LICENSE for license information.
 */

// LEVEL: 0
// ERRCHECK: %compiler %cmp_opt %f -o %output

interface I<T> {
    static func default(): T
}

extend Int64 <: I<Int64> {
    public static func default(): Int64 {
        1
    }
}

enum A<T> where T <: I<T> {
    EA
}

extend<T> A<T> <: II<T> {
    static prop pa: T {
        get() {
            T.default()
        }
    }
}

interface II<T> {
    mut static prop pa: Int64
}

main() {
    return 1
}
// ASSERT: scan sema_interface_is_not_extendable
// ASSERT: scan sema_prop_redefinition
// ASSERT: scan sema_static_variable_use_generic_parameter
