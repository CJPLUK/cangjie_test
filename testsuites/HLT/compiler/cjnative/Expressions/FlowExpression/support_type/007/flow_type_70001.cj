/*
 * Copyright (c) Huawei Technologies Co., Ltd. 2025. All rights reserved.
 * This source file is part of the Cangjie project, licensed under Apache-2.0
 * with Runtime Library Exception.
 * 
 * See https://cangjie-lang.cn/pages/LICENSE for license information.
 */

// LEVEL: 1
// ERRCHECK: %compiler %cmp_opt %f -o %output

func f(input:Int64):Int64 {0}

main(): Int64 {
    Bool |> f 
    return 1
}
// ASSERT: scan parse_expected_character
// ASSERT: scan parse_expected_expression
