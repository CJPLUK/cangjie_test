// Copyright (c) Huawei Technologies Co., Ltd. 2026. All rights reserved.
// This source file is part of the Cangjie project, licensed under Apache-2.0
// with Runtime Library Exception.
//
// See https://cangjie-lang.cn/pages/LICENSE for license information.

// Regression: the resource variable of `try-with-resources` is of a generic type parameter whose
// upper bound is a class instead of an interface. The `close` found in the upper bound must still
// be dispatched to the override of the actual type argument.

// EXEC: %compiler %cmp_opt %compile_exe_opt %f -o %output
// RUN-EXEC-PIPE: %run %run_opt %output %run_args | compare %f

open class Base <: Resource {
    public func isClosed(): Bool {
        return false
    }
    public open func close(): Unit {
        println("base close")
    }
}

class Derived <: Base {
    public override func close(): Unit {
        println("derived close")
    }
}

func use<T>(r: T): Unit where T <: Base {
    try (x = r) {
        println("body")
    }
}

main() {
    use<Derived>(Derived())
}

/* SCAN
body
derived close
*/
