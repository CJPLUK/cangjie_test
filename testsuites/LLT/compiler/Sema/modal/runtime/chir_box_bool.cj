// Copyright (c) Huawei Technologies Co., Ltd. 2026. All rights reserved.
// This source file is part of the Cangjie project, licensed under Apache-2.0
// with Runtime Library Exception.
//
// See https://cangjie-lang.cn/pages/LICENSE for license information.

// ERRCHECK: %compiler %local %f -Woff all %diag_json 2>&1

class Param {}

interface Adapt<T> {
    static func fromV(p: Param @local!): T @local!
}
extend Bool <: Adapt<Bool> {
    public static func fromV(p: Param @local!): Bool {
        true
    }
}

main() {}

// ASSERT: scan-1 "DiagKind": "sema_return_type_incompatible",
// ASSERT: scan "Errors": 1,
