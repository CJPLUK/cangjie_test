// Copyright (c) Huawei Technologies Co., Ltd. 2026. All rights reserved.
// This source file is part of the Cangjie project, licensed under Apache-2.0
// with Runtime Library Exception.
//
// See https://cangjie-lang.cn/pages/LICENSE for license information.

// EXEC: %compiler %local %f -o %output
// RUN-EXEC: %run %run_opt %output %run_args

class C {
    init() {
        _s = "Hello"
    }
    init(this @local!) {
        exclave {
            _s = "Hello"
        }
    }
    mut prop val: Int64 {
        get() { 1 }
        set(v) { }
    }
    mut prop val2: Int64 @local! {
        get() { 2 }
        set(v) { }
    }
    mut prop val3: Int64 {
        get() { 3 }
        set(value) {
            let _ = value
        }
    }
    mut prop val3: Int64 @local! {
        get() { 3 }
        set(value) {
            let _ = value
        }
    }

    mut prop s: String {
        get() { _s }
        set(value) { _s = value }
    }
    mut prop s: String @local! {
        get() {
            exclave {_s}
        }
        set(value) {
            exclave {
                _s = value
            }
        }
    }
    private var _s: String
}

main() {
    let c: C @~local = C()
    let a: Int = c.val
    let e: Int = c.val3
    println(a)
    println(e)
    c.val = 8
    c.s = "Hello"

    let d: C @local! = C()
    let b = d.val2
    println(b)
    d.val2 = 9
    d.val3 = 10
    d.s = "Hello"
}
