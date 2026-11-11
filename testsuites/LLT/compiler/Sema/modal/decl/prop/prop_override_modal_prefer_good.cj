// Copyright (c) Huawei Technologies Co., Ltd. 2026. All rights reserved.
// This source file is part of the Cangjie project, licensed under Apache-2.0
// with Runtime Library Exception.
//
// See https://cangjie-lang.cn/pages/LICENSE for license information.

// EXEC: %compiler %local %f -o %output
// RUN-EXEC: %run %run_opt %output %run_args

open class P {
    init() {}
    init(this @local!) { exclave {} }
    public open prop p: Int64 @local? { get() { 777 } }
    public open prop p: Int64 @local! { get() { 888 } }
}

class C <: P {
    init() {}
    init(this @local!) { exclave { super() } }
    public override prop p: Int64 @local? { get() { 42 } }
    public override prop p: Int64 @local! { get() { 43 } }
}

class D <: P {
    init() {}
    init(this @local!) { exclave { super() } }
    public override prop p: Int64 @local! { get() { 53 } }
    public override prop p: Int64 @local? { get() { 52 } }
}

func which(o: C @local!): Int64 { exclave { o.p } }
func maybe(o: C @local?): Int64 { o.p }
func reversed(o: D @local!): Int64 { exclave { o.p } }
func reversedMaybe(o: D @local?): Int64 { o.p }

main(): Int64 {
    let c = C() @local!
    let d = D() @local!
    if (which(c) != 43 || maybe(c) != 42 || maybe(C()) != 42) {
        return 1
    }
    if (reversed(d) != 53 || reversedMaybe(d) != 52 || reversedMaybe(D()) != 52) {
        return 1
    }
    return 0
}
