// Copyright (c) Huawei Technologies Co., Ltd. 2026. All rights reserved.
// This source file is part of the Cangjie project, licensed under Apache-2.0
// with Runtime Library Exception.
//
// See https://cangjie-lang.cn/pages/LICENSE for license information.

// EXEC: %compiler %local %f -Woff all -o %output
// RUN-EXEC: %run %run_opt %output %run_args
// EXEC: %compiler %local %enableO2 %f -Woff all -o %output
// RUN-EXEC: %run %run_opt %output %run_args

func genericArray<T>(value: T): Int64 {
    var size = 0
    try {
        let a: Array<T> @local? = [value, value]
        size = a.size
        throw Exception("expected")
    } catch (e: Exception) {
        return size
    }
}

main(): Int64 {
    try {
        let a: Array<Int64> @local! = [1, 2]
        println(a.size)
        if (a.size != 2 || a[0] != 1 || a[1] != 2) {
            return 1
        }
    } catch (e: Exception) {
        return 2
    }
    if (genericArray<Int64>(7) != 2 || genericArray<String>("value") != 2) {
        return 3
    }
    return 0
}
