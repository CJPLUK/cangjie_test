/*
 * Copyright (c) Huawei Technologies Co., Ltd. 2026. All rights reserved.
 * This source file is part of the Cangjie project, licensed under Apache-2.0
 * with Runtime Library Exception.
 * 
 * See https://cangjie-lang.cn/pages/LICENSE for license information.
 */

// EXEC: %compiler %cmp_opt %f -o %output
// ERRCHECK: %run %run_opt %output %run_args
// ASSERT: scan-begin at pkg1.pkg2::A::init()
// ASSERT: scan-next at pkg1.pkg2::global_a

package pkg1.pkg2

class A {
    init() {
        throw Exception()
    }
}

var global_a: A = A()

main() {
    return 0
}
