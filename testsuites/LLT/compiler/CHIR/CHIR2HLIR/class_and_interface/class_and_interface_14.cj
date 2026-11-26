// Copyright (c) Huawei Technologies Co., Ltd. 2025. All rights reserved.
// This source file is part of the Cangjie project, licensed under Apache-2.0
// with Runtime Library Exception.
//
// See https://cangjie-lang.cn/pages/LICENSE for license information.

// LEVEL: 0
// EXEC-PIPE-1: %compiler %cmp_opt %enableCompileDebug %f %diag_json -o %n.%suffix 2>&1 | compare %f

public open class class8<T> {
    public static func func644<T, X>(): UInt32 {
        0
    }
}

public open class Class7 <: class8<Int64> {
    public static func func644<T>(): UInt32 where T <: Int64 {
        UInt32(3)
    }
}

main() {
    Class7.func644()
    0
}
// ASSERT: scan sema_upper_bound_must_be_class_or_interface
// ASSERT: scan sema_generic_member_type_argument_different
// ASSERT: scan function 'func644' type parameter count is 1, but its inherited declaration requires 2
// ASSERT: scan inherited declaration is here
