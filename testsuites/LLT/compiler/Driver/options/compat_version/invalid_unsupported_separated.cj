// Copyright (c) Huawei Technologies Co., Ltd. 2026. All rights reserved.
// This source file is part of the Cangjie project, licensed under Apache-2.0
// with Runtime Library Exception.
//
// See https://cangjie-lang.cn/pages/LICENSE for license information.

// An unsupported version reports the whitelist of supported versions.
// NOTE: language plugins rely on this message to obtain the whitelist, do not change it.
// EXEC-PIPE-1: %compiler %cmp_opt %f --compat-version 1.2 -o %output 2>&1 | compare %f
// ASSERT: scan invalid compat version, supported compatible versions: [1.3]
// ASSERT: scan-not invalid value
// ASSERT: scan Try: 'cjc --help' for more information.

main() {
    return 0
}
