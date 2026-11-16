// Copyright (c) Huawei Technologies Co., Ltd. 2026. All rights reserved.
// This source file is part of the Cangjie project, licensed under Apache-2.0
// with Runtime Library Exception.
//
// See https://cangjie-lang.cn/pages/LICENSE for license information.

// Regression: the resource variable of `try-with-resources` is a member of a generic class and
// takes the type parameter of that class as its type. The resource is closed by the desugared
// `finally` block, which needs the members inherited from the class type parameter's upper bound.

// EXEC: %compiler %cmp_opt %compile_exe_opt %f -o %output
// RUN-EXEC-PIPE: %run %run_opt %output %run_args | compare %f

class Res <: Resource {
    public func isClosed(): Bool {
        return false
    }
    public func close(): Unit {
        println("close")
    }
}

class Holder<T> where T <: Resource {
    let res: T
    public init(res: T) {
        this.res = res
    }
    public func run(): Unit {
        try (x = res) {
            println("body")
        }
    }
}

main() {
    Holder<Res>(Res()).run()
}

/* SCAN
body
close
*/
