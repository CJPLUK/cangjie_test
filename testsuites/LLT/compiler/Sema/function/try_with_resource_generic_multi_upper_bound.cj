// Copyright (c) Huawei Technologies Co., Ltd. 2026. All rights reserved.
// This source file is part of the Cangjie project, licensed under Apache-2.0
// with Runtime Library Exception.
//
// See https://cangjie-lang.cn/pages/LICENSE for license information.

// Regression: the resource variable of `try-with-resources` is of a generic type parameter with
// several upper bounds, and 'Resource' is only one of them. The desugared `x.isClosed()` /
// `x.close()` need the members of 'Resource' to be found among all upper bounds.

// EXEC: %compiler %cmp_opt %compile_exe_opt %f -o %output
// RUN-EXEC-PIPE: %run %run_opt %output %run_args | compare %f

interface Extra {
    func extra(): Unit
}

class Res <: Resource & Extra {
    public func isClosed(): Bool {
        return false
    }
    public func close(): Unit {
        println("close")
    }
    public func extra(): Unit {}
}

func use<T>(r: T): Unit where T <: Resource & Extra {
    try (x = r) {
        x.extra()
        println("body")
    }
}

main() {
    use(Res())
}

/* SCAN
body
close
*/
