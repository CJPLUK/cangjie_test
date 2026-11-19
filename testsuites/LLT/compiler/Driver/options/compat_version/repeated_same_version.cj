// Copyright (c) Huawei Technologies Co., Ltd. 2026. All rights reserved.
// This source file is part of the Cangjie project, licensed under Apache-2.0
// with Runtime Library Exception.
//
// See https://cangjie-lang.cn/pages/LICENSE for license information.

// The same version specified multiple times (in different forms) is accepted silently.
// EXEC-PIPE: %compiler %cmp_opt %f --compat-version 1.3 --compat-version=1.3 -o %output 2>&1 | compare %f
// ASSERT: scan-not error
// ASSERT: scan-not warning
// ASSERT: scan-not specified multiple times

main() {
    return 0
}
