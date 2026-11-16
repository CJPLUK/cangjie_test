// Copyright (c) Huawei Technologies Co., Ltd. 2026. All rights reserved.
// This source file is part of the Cangjie project, licensed under Apache-2.0
// with Runtime Library Exception.
//
// See https://cangjie-lang.cn/pages/LICENSE for license information.

// EXEC-PIPE-1: %compiler --enable-local-mode %f 2>&1 | compare %f

main() {}

// ASSERT: scan --enable-local-mode is an experimental feature. "--experimental" option is required to enable experimental features.
