/*
 * Copyright (c) Huawei Technologies Co., Ltd. 2026. All rights reserved.
 * This source file is part of the Cangjie project, licensed under Apache-2.0
 * with Runtime Library Exception.
 * 
 * See https://cangjie-lang.cn/pages/LICENSE for license information.
 */

func longexpr(a: Int64, b: Int64, c: Int64, d: Int64): Int64 {
    let total = a + b + c + d + a + b + c + d + a /* mark */ + b + c + d + a + b + c + d + a + b + c + d + a + b + c +
        d + a + b + c + d
    return total
}

main() {
    println(longexpr(1, 2, 3, 4))
}
