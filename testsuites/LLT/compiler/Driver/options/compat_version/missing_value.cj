// Copyright (c) Huawei Technologies Co., Ltd. 2026. All rights reserved.
// This source file is part of the Cangjie project, licensed under Apache-2.0
// with Runtime Library Exception.
//
// See https://cangjie-lang.cn/pages/LICENSE for license information.

// The option requires a value.
// EXEC-PIPE-1: %compiler %cmp_opt %f --compat-version 2>&1 | compare %f
// ASSERT: scan this Option needs a value: '--compat-version'

main() {
    return 0
}
