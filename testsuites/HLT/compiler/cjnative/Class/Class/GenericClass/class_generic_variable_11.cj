/*
 * Copyright (c) Huawei Technologies Co., Ltd. 2025. All rights reserved.
 * This source file is part of the Cangjie project, licensed under Apache-2.0
 * with Runtime Library Exception.
 * 
 * See https://cangjie-lang.cn/pages/LICENSE for license information.
 */

// LEVEL: 0
// EXEC-PIPE-1: %compiler %cmp_opt %f -o %output 2>&1 | compare %f

open class Base<T> {
    public var base: T
    public init(x: T) {
        base = x
    }
}

func foo(): Int32 {
    return 3
}

class Data<T> <: Base<Int32> {
    public static var f: () -> T
    public init(input: T) {
        f = foo
    }
}

main(): Int64 {
    var i1: () -> Int32
    var data: Data<Int32> = Data<Int32>(i1)
    var res: Int32 = Data<Int32>.f()
    if (res == 3) {
        return 0
    }
    return 1
}
// ASSERT: scan sema_mismatched_types
// ASSERT: scan sema_no_non_param_constructor_in_super_class
// ASSERT: scan sema_static_variable_use_generic_parameter
// ASSERT: scan sema_type_incompatible
// ASSERT: scan sema_type_uninitialized_static_field
// ASSERT: scan sema_used_before_initialization
