/*
 * Copyright (c) Huawei Technologies Co., Ltd. 2025. All rights reserved.
 * This source file is part of the Cangjie project, licensed under Apache-2.0
 * with Runtime Library Exception.
 * 
 * See https://cangjie-lang.cn/pages/LICENSE for license information.
 */

// LEVEL: 1
// EXEC-PIPE-1: %compiler %cmp_opt %f 2>&1 | compare %f

func test(test`test`test:Int64): Int64 {
    return test`test`test
}

main(): Int64 {
    return test(0)
}
// ASSERT: scan parse_expected_character
