/*
 * Copyright (c) Huawei Technologies Co., Ltd. 2025. All rights reserved.
 * This source file is part of the Cangjie project, licensed under Apache-2.0
 * with Runtime Library Exception.
 * 
 * See https://cangjie-lang.cn/pages/LICENSE for license information.
 */

// LEVEL: 0
// ERRCHECK: %compiler %cmp_opt %f -o %output


main() : Int64 {
    var a:Data<Int32> = Data<Int32>()
    if ( a +<Int64> 1 != 0){
        return 1
    }
    if ( a + Int64(2) != 0){
        return 2
    }
    return 0
}

class Data<T> {
    public operator func +<V>(right:Int64):UInt8  {return 0}
}
// ASSERT: scan parse_expected_expression
