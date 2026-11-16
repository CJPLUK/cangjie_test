/*
 * Copyright (c) Huawei Technologies Co., Ltd. 2025. All rights reserved.
 * This source file is part of the Cangjie project, licensed under Apache-2.0
 * with Runtime Library Exception.
 * 
 * See https://cangjie-lang.cn/pages/LICENSE for license information.
 */

// LEVEL: 2
// ERRCHECK: %compiler %cmp_opt %f -o %output 


import define

main(){
    4 - @D[0]var x = @B var ye.*

main(){
    4 - @D[0]var x = @B var y = 0 + @D[0]var z = 0 + @X[0](0) + @A(0)
}
// ASSERT: scan parse_expected_expression
// ASSERT: scan parse_expected_name
// ASSERT: scan parse_expected_right_delimiter
// ASSERT: scan parse_expected_type_or_init_in_pattern
