/*
 * Copyright (c) Huawei Technologies Co., Ltd. 2025. All rights reserved.
 * This source file is part of the Cangjie project, licensed under Apache-2.0
 * with Runtime Library Exception.
 * 
 * See https://cangjie-lang.cn/pages/LICENSE for license information.
 */

// LEVEL: 1
// DESCRIPTION: more than two consecutive colons, 4 exactly.
// EXEC-PIPE-1: %compiler %cmp_opt %compile_lib_opt %f 2>&1 | compare %f
// ASSERT: scan expected a package name after '::' in qualified name, found '::'

package org::::pkg
