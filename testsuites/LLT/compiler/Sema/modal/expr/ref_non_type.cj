// Copyright (c) Huawei Technologies Co., Ltd. 2026. All rights reserved.
// This source file is part of the Cangjie project, licensed under Apache-2.0
// with Runtime Library Exception.
//
// See https://cangjie-lang.cn/pages/LICENSE for license information.

// EXEC-PIPE-1: %compiler %local %f %diag_json 2>&1 | compare %f

class C {
    func foo() {
        let a = this @~local
    }
    var c = 3

    func bar() {
        foo () @local?
        c @~local
    }
    func baz() {
        let a = foo @local?
        a()
    }
}

struct S<T> {
    func foo() {
        let a = this @~local
    }
    var c = 3

    func bar() {
        foo () @local?
        c @~local
    }

    func jar(): T @~local {
        throw Exception()
    }
}

open class O {
    public open func foo() {}
}
class D <: O {
    public override func foo() {
        super @~local .foo()
    }

    public open func jar(): This @~local {
        return this
    }
}

main() {}

// ASSERT: scan-5 "DiagKind": "parse_expected_character",
// ASSERT: scan-3 "DiagKind": "parse_expected_expr_or_decl_in",
