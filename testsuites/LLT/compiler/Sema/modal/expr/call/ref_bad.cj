// Copyright (c) Huawei Technologies Co., Ltd. 2026. All rights reserved.
// This source file is part of the Cangjie project, licensed under Apache-2.0
// with Runtime Library Exception.
//
// See https://cangjie-lang.cn/pages/LICENSE for license information.

// ERRCHECK: %compiler %local %f -Woff all %diag_json 2>&1

class C {
    init() {}
    exclave init(this @local!) { }

    static func bar() { }
}

type Al = C

func foo() {
    let a = C @local! ()
    let b = Al @local! ()
    C @local! .bar()
    Int64 @local! . Max
}
main() {}
// ASSERT: scan-3 "DiagKind": "parse_expected_character",
// ASSERT: scan-1 "DiagKind": "parse_unexpected_modal_type",
