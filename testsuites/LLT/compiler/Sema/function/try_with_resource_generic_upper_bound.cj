// Copyright (c) Huawei Technologies Co., Ltd. 2026. All rights reserved.
// This source file is part of the Cangjie project, licensed under Apache-2.0
// with Runtime Library Exception.
//
// See https://cangjie-lang.cn/pages/LICENSE for license information.

// Regression: the resource variable of `try-with-resources` is of a generic type parameter whose
// upper bound is the 'Resource' interface. Compiling this used to crash while desugaring, since the
// members of a generic type parameter were looked up from a null decl.
// The desugared `x.isClosed()` / `x.close()` must be found in the upper bound, and `close` must not
// be called when the resource reports itself as already closed.

// EXEC: %compiler %cmp_opt %compile_exe_opt %f -o %output
// RUN-EXEC-PIPE: %run %run_opt %output %run_args | compare %f

class Res <: Resource {
    let closed: Bool
    public init(closed: Bool) {
        this.closed = closed
    }
    public func isClosed(): Bool {
        return closed
    }
    public func close(): Unit {
        println("close")
    }
}

func use<T>(r: T): Unit where T <: Resource {
    try (x = r) {
        println("body")
    }
}

main() {
    use(Res(false))
    use(Res(true))
}

/* SCAN
body
close
body
*/
