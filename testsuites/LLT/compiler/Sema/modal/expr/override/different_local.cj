// Copyright (c) Huawei Technologies Co., Ltd. 2026. All rights reserved.
// This source file is part of the Cangjie project, licensed under Apache-2.0
// with Runtime Library Exception.
//
// See https://cangjie-lang.cn/pages/LICENSE for license information.

// ERRCHECK: %compiler %local %f -Woff all %diag_json 2>&1
abstract class I {
    public open func foo(): Int64
}

class C <: I {
    func foo(this @local?): Int64 {
        1
    }
}

main() {}
// ASSERT: scan-1 "DiagKind": "sema_class_need_abstract_modifier_or_func_need_impl",
// ASSERT: scan "Errors": 1,