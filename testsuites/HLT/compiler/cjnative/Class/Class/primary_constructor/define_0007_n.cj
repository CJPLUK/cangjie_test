/*
 * Copyright (c) Huawei Technologies Co., Ltd. 2025. All rights reserved.
 * This source file is part of the Cangjie project, licensed under Apache-2.0
 * with Runtime Library Exception.
 * 
 * See https://cangjie-lang.cn/pages/LICENSE for license information.
 */

// LEVEL: 0
// EXEC-PIPE-1: %compiler %cmp_opt %compile_lib_opt %f 2>&1 | compare %f




class Data  {
    public Data(in:Int32){ 
        print(in.toString())
    }
}
func run(): Int64 {
    var data: Data = Data(2)
    return 0
}
main(): Int64 {
    return run()
}
// ASSERT: scan parse_expected_name
// ASSERT: scan parse_expected_expression
// ASSERT: scan parse_expected_expr_or_decl_in
