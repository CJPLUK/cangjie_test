/*
 * Copyright (c) Huawei Technologies Co., Ltd. 2026. All rights reserved.
 * This source file is part of the Cangjie project, licensed under Apache-2.0
 * with Runtime Library Exception.
 * 
 * See https://cangjie-lang.cn/pages/LICENSE for license information.
 */

// EXEC: %compiler %local %cmp_opt %f -o %output
// ERRCHECK: %run %run_opt %output %run_args
// ASSERT: scan at pkg1.pkg2::A::init(this @ local!)

package pkg1.pkg2

class A {
    exclave init(this @ local!) {
        throw Exception()
    }
}

main() {
    var value: A @ local! = A()
    return 0
}
