/*
 * Copyright (c) Huawei Technologies Co., Ltd. 2025. All rights reserved.
 * This source file is part of the Cangjie project, licensed under Apache-2.0
 * with Runtime Library Exception.
 * 
 * See https://cangjie-lang.cn/pages/LICENSE for license information.
 */

// LEVEL: 0
//ERRCHECK:  %compiler %cmp_opt %f -o %output

class Aoo<T> where T<: ?Int32 {
    public var a : T
    public init(x:T){
        a = x
    }
}

/**
0.22spec上只能在标注类型的地方使用？Type，后续spec会改？Type可以用在所有Type能用的地方
*/
main() {
   var a1 = Aoo<?Int32>((?Int32).Some(1)) 
   if ( match (a1.a) { case Some(x) => !true;case _ => !false} ){
       return 1
   }
   return 0
}
// ASSERT: scan parse_expected_expression
