// Copyright (c) Huawei Technologies Co., Ltd. 2026. All rights reserved.
// This source file is part of the Cangjie project, licensed under Apache-2.0
// with Runtime Library Exception.
//
// See https://cangjie-lang.cn/pages/LICENSE for license information.

// cjc-frontend reports the same whitelist message.
// EXEC-PIPE-1: %frontendCompiler %cmp_opt %f --compat-version 1.2 2>&1 | compare %f
// ASSERT: scan invalid compat version, supported compatible versions: [1.3]
// ASSERT: scan Try: 'cjc-frontend --help' for more information.

main() {
    return 0
}
