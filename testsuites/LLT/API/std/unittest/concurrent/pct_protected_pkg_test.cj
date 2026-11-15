/*
 * Copyright (c) Huawei Technologies Co., Ltd. 2026. All rights reserved.
 * This source code is part of the Cangjie project, licensed under Apache-2.0
 * with Runtime Library Exception.
 *
 * See https://cangjie-lang.cn/pages/LICENSE for license information.
 */

// LEVEL: 0
// NOTE: stdx.unittest.sync is an internal package: the only sanctioned way it
// enters a compilation is the compiler's own --cj-pct rewrite of `std.sync`
// imports. Both hand-written forms below (without and with --cj-pct) must be
// rejected by the package accessibility check. The stdx import path is
// needed so the package's cjo (and its internal accessibility) is found.
// ERRCHECK: %compiler %cmp_opt %cangjie-stdx-import-path %f -o %output
// ERRCHECK: %compiler %cmp_opt --experimental --cj-pct %cangjie-stdx-import-path %f -o %output
// ASSERT: scan package 'stdx.unittest.sync' is 'internal' which cannot be imported by irrelevant package

import stdx.unittest.sync.*

main(): Int64 {
    return 0
}
