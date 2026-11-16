// Copyright (c) Huawei Technologies Co., Ltd. 2026. All rights reserved.
// This source file is part of the Cangjie project, licensed under Apache-2.0
// with Runtime Library Exception.
//
// See https://cangjie-lang.cn/pages/LICENSE for license information.

// DEPENDENCE: %n.lib.cj
// EXEC: %compiler %local %n.lib.cj %compile_lib_opt -o %n.%middle
// ERRCHECK: %compiler %local %f -Woff all %diag_json %n.%middle 2>&1
import lib

func foo() {
    lib.C @local! .bar()
    lib.Al @local! .bar()
    lib.F @local! . Max
}
main() {}
// ASSERT: scan-3 "DiagKind": "parse_expected_character",
