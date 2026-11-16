/*
 * Copyright (c) Huawei Technologies Co., Ltd. 2025. All rights reserved.
 * This source file is part of the Cangjie project, licensed under Apache-2.0
 * with Runtime Library Exception.
 * 
 * See https://cangjie-lang.cn/pages/LICENSE for license information.
 */

// LEVEL: 1
// EXEC: %compiler %cmp_opt %f -o %output
// RUN-EXEC-PIPE-1: %run %run_opt %output %run_args 2>&1 | compare %f
// ASSERT: scan-not exception caught
// ASSERT: scan MyException
// (!O2) ASSERT: scan at default::C::lambda.0()
// ASSERT: scan at default::C::b

class MyException <: Exception {
    public func toString(): String {
        "MyException"
    }
}

struct C {
    public static var a: (Int64) -> Int64 = {
        x: Int64 => if (x == 1) {
            throw MyException();
            1
        } else {
            1
        }
    }
    public static var b: Int64 = a(1)
}

main() {
    try {
        C();
        ()
    } catch (a: Exception) {
        print("exception caught")
    }
    return 0
}
