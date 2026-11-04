// Copyright (c) Huawei Technologies Co., Ltd. 2025. All rights reserved.
// This source file is part of the Cangjie project, licensed under Apache-2.0
// with Runtime Library Exception.
//
// See https://cangjie-lang.cn/pages/LICENSE for license information.

// Regression test for a CJMP reproducibility bug: when a platform-layer (specific)
// compilation reuses a common part compiled with --output-type=chir, the implicitly
// injected `import std.core.*` of the common layer lost its IMPLICIT_ADD attribute
// across CJO serialization and leaked into pkgDepInfo's `dependencies` array.
// `std.core` must remain reported only under `std-dependencies`.

// SEPARATE-FILE: c/c.cj
// EXEC-0: %compiler %noColor --experimental c/c.cj --output-type=chir --output-dir ./c
package cmp

public common func foo(): Int64 {
  return 1
}

// SEPARATE-FILE: p/p.cj
// EXEC-0: %compiler %noColor --experimental p/p.cj --common-part-chir=c/cmp.chir --common-part-cjo=./c/cmp.cjo --output-dir=p --output-type=chir
package cmp

public specific func foo(): Int64 {
  return 2
}

// SEPARATE-FILE: main.cj
// EXEC: %compiler --scan-dependency p/cmp.cjo 2>&1 | compare %f
// ASSERT: scan "std-dependencies":[{"std.core":[]}]
// ASSERT: scan-not "package":"std.core"

main() {}
