// Copyright (c) Huawei Technologies Co., Ltd. 2026. All rights reserved.
// This source file is part of the Cangjie project, licensed under Apache-2.0
// with Runtime Library Exception.
//
// See https://cangjie-lang.cn/pages/LICENSE for license information.

// `--help` shows the option and its candidate versions.
// EXEC: %compiler --help 2>&1 | compare %f
// ASSERT: scan --compat-version <value>
// ASSERT: scan Compile with compatibility behavior for the specified SDK version. Candidate versions:
// ASSERT: scan <value>=1.3

main() {
    return 0
}
