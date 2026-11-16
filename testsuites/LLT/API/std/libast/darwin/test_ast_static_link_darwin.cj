// Copyright (c) Huawei Technologies Co., Ltd. 2026. All rights reserved.
// This source file is part of the Cangjie project, licensed under Apache-2.0
// with Runtime Library Exception.
//
// See https://cangjie-lang.cn/pages/LICENSE for license information.

// Regression test for issue 794: on Darwin, with --static enabled, the driver
// still linked the dynamic libcangjie-std-ast.dylib for programs importing
// std.ast, leaving a mixed static/dynamic std. The driver must link the
// static libcangjie-std-ast.a instead.
// Darwin-only: the bug and the otool-based check are mac specific.

// (CJNATIVE and Darwin) EXEC: %compiler %cmp_opt --static %f -o %output
// (CJNATIVE and Darwin) EXEC-PIPE: %ldd %output | compare %f
// (CJNATIVE and Darwin) ASSERT: regex-not libcangjie-std-ast\.dylib

import std.ast.*

main() {
    1
}
