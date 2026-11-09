/*
 * Copyright (c) Huawei Technologies Co., Ltd. 2026. All rights reserved.
 * This source file is part of the Cangjie project, licensed under Apache-2.0
 * with Runtime Library Exception.
 *
 * See https://cangjie-lang.cn/pages/LICENSE for license information.
 */

// EXEC: %compiler %cmp_opt %f -o %output
// ERRCHECK: %run %run_opt %output %run_args
// ASSERT: scan-begin at pkg1.pkg2::main::test_input::test_input_3(Int64)
// ASSERT: scan-next at pkg1.pkg2::main::test_input(Int64)
// ASSERT: scan-next at pkg1.pkg2::main()

package pkg1.pkg2

main() {
    func test_input(x: Int64) {
        func test_input_3(y: Int64) {
            throw Exception()
        }
        test_input_3(x)
    }
    test_input(10)
    return 0
}
