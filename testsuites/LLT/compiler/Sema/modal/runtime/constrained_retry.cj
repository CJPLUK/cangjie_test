// Copyright (c) Huawei Technologies Co., Ltd. 2026. All rights reserved.
// This source file is part of the Cangjie project, licensed under Apache-2.0
// with Runtime Library Exception.
//
// See https://cangjie-lang.cn/pages/LICENSE for license information.

// EXEC: %compiler %local %f -o %output
// EXEC: %run %run_opt %output %run_args

extend<T> Array<T> where T <: Equatable<T> {
    public func myContainsCE(this @local?, element: T @local?): Bool {
        var idx: Int64 = this.size - 1
        while (idx >= 0) {
            let o: Option<T> @local? = this.get(idx)
            match (o) {
                case Some(v) =>
                    if (v == element) {
                        return true
                    }
                case None => ()
            }
            idx = idx - 1
        }
        false
    }
}

func assertB(actual: Bool, name: String): Int64 {
    if (!actual) {
        println("FAIL: ${name}")
        return 1
    }
    return 0
}

main(): Int64 {
    var failed = 0
    let a1: Array<Int64> @local? = [1, 2, 3]
    let elem: Int64 @local? = a1[1]
    failed += assertB(a1.myContainsCE(elem), "constrained_explicit_local")
    failed += assertB(a1.myContainsCE(2), "constrained_plain_literal")
    if (failed > 0) { return 1 }
    println("ALL PASSED")
    return 0
}
