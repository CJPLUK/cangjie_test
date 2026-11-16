// Copyright (c) Huawei Technologies Co., Ltd. 2026. All rights reserved.
// This source file is part of the Cangjie project, licensed under Apache-2.0
// with Runtime Library Exception.
//
// See https://cangjie-lang.cn/pages/LICENSE for license information.

// EXEC-PIPE-1: %compiler %local %f -Woff all %diag_json --error-count-limit=all 2>&1 | compare %f

class D {
    init() {}
    init(this @local!) { exclave {} }
}

class C {
    demode var ok: D
    init() { ok = D() }
}

demode class AnnotatedClass {
    init() {}
}

demode func globalFunc() {}

demode let globalVar: Int64 = 0

class BadSites {
    demode static var staticField: Int64 = 0

    demode mut prop p: Int64 {
        get() { 0 }
        set(v) {}
    }

    demode func memberFunc() {}

    var dupField: D

    func localSite() {
        demode var localVar: Int64 = 0
    }

    init(demode n: Int64) {
        dupField = D()
    }
}

demode[x]
class WithArg {
    init() {}
}

main() {}

// ASSERT: scan-6 "DiagKind": "parse_illegal_modifier_in_scope",
// ASSERT: scan-1 "DiagKind": "parse_conflict_modifier",
// ASSERT: scan-1 "DiagKind": "parse_expected_no_modifier",
// ASSERT: scan-1 "DiagKind": "parse_expected_decl",
// ASSERT: scan "Errors": 9,
