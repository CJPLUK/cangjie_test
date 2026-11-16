// Copyright (c) Huawei Technologies Co., Ltd. 2026. All rights reserved.
// This source file is part of the Cangjie project, licensed under Apache-2.0
// with Runtime Library Exception.
//
// See https://cangjie-lang.cn/pages/LICENSE for license information.

// EXEC: %compiler %local %f -o %output
// EXEC: %run %run_opt %output %run_args

// Compare maybe-local values through a constrained extension.
extend<T> Array<T> where T <: Equatable<T> {
    public func containsAny(this @local?, element: T @local?): Bool {
        var idx: Int64 = this.size - 1
        while (idx >= 0) {
            let o: Option<T> @local? = this.get(idx)
            if (let Some(v) <- o) {
                if (v == element) {
                    return true
                }
            }
            idx = idx - 1
        }
        false
    }
}

main(): Int64 {
    let a1: Array<Int64> @local? = [1, 2, 3]
    let elem: Int64 @local? = a1[1]
    let r = a1.containsAny(elem)
    println("containsAny=${r}")
    return if (r) { 0 } else { 1 }
}
