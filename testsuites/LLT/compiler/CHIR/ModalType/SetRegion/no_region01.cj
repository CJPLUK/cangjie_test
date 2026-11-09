// Copyright (c) Huawei Technologies Co., Ltd. 2026. All rights reserved.
// This source file is part of the Cangjie project, licensed under Apache-2.0
// with Runtime Library Exception.
//
// See https://cangjie-lang.cn/pages/LICENSE for license information.

// LEVEL: 0
// EXEC: %compiler %local %n.cj %dumpCHIRDebug -o %output
// RUN-EXEC: %run %run_opt %output
// EXEC: %cat no_region01_CHIR/[0-9]*_AST_CHIR.chirtxt | compare %f
// ASSERT: scan-not StartRegion
// ASSERT: scan-not EndRegion

interface III {
    func foo() {
        print("III::foo")
    }
}

class AAA <: III {
    var a = 1
    init() {}
    public func foo() {
        print("AAA::foo")
    }
    private func goo() {
        a = 2
    }
    protected mut prop b: Int64 {
        get() {
            a
        }
        set(value) {
            a = value
        }
    }
}

private func hoo() {
    print("hoo")
}

main() {
    var a = AAA()
    a.foo()
    a.b = 3
    println("a.b = ${a.b}")
    hoo()
}