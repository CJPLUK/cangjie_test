/*
 * Copyright (c) Huawei Technologies Co., Ltd. 2025. All rights reserved.
 * This source file is part of the Cangjie project, licensed under Apache-2.0
 * with Runtime Library Exception.
 * 
 * See https://cangjie-lang.cn/pages/LICENSE for license information.
 */

// LEVEL: 1
// EXEC-PIPE-1: %compiler %cmp_opt %f 2>&1 | compare %f

main(): Int64 {
    var a: String = "if"
    var t: Bool = true
    var f: Bool = false
    if (a || a) {  
        return 1
    }
    if (if (|| t)) {  
        return 1
    }
    if (f || int) {  
        return 1
    }
    return 0 
}
// ASSERT: scan parse_expected_expression
// ASSERT: scan parse_expected_right_delimiter
