// Copyright (c) Huawei Technologies Co., Ltd. 2026. All rights reserved.
// This source file is part of the Cangjie project, licensed under Apache-2.0
// with Runtime Library Exception.
//
// See https://cangjie-lang.cn/pages/LICENSE for license information.

// EXEC: %compiler %local %cmp_opt %f -o %output
// EXEC: %run %run_opt %output %run_args

func go<T>(f: () -> T): T { f() }

class C {
    public func earlier(): Unit {
        go { => later(None) }
    }
    private func later(_init: ?String) {
        let s = match (_init) { case Some(v) => v; case None => "None" }
        println(s)
    }
}

main() {
    C().earlier()
    0
}
