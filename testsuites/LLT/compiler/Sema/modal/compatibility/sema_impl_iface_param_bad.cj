// Copyright (c) Huawei Technologies Co., Ltd. 2026. All rights reserved.
// This source file is part of the Cangjie project, licensed under Apache-2.0
// with Runtime Library Exception.
//
// See https://cangjie-lang.cn/pages/LICENSE for license information.

// DEPENDENCE: pkg_iface.cj
// EXEC: %compiler %local %compile_lib_opt pkg_iface.cj -o pkg_iface.%middle
// EXEC-PIPE-1: %compiler %cmp_opt pkg_iface.%middle %f -o %output %diag_json 2>&1 | compare %f

import pkg_iface.*

class D <: IParam {
    public func f(a: Int64): Unit {}
}

main() {}

// ASSERT: scan "DiagKind": "sema_class_need_abstract_modifier_or_func_need_impl",
