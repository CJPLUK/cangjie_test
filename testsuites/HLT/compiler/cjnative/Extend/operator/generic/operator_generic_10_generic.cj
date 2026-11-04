/*
 * Copyright (c) Huawei Technologies Co., Ltd. 2025. All rights reserved.
 * This source file is part of the Cangjie project, licensed under Apache-2.0
 * with Runtime Library Exception.
 * 
 * See https://cangjie-lang.cn/pages/LICENSE for license information.
 */

// LEVEL: 0
// EXEC-PIPE-1: %compiler %cmp_opt %f -o %output 2>&1 | compare %f


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
}

interface I<T>{
    operator func +(right:Int64):UInt8  {return 0}
    operator func -(right:T):T  {return right}
}

extend<T> Data<T> <: I<T> {
    public operator func +(right:Int64):UInt8  {return 0}
    public operator func -(right:T):T  {return right}
}
// ASSERT: scan parse_expected_expression
