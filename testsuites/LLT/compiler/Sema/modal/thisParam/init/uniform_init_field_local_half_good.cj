// Copyright (c) Huawei Technologies Co., Ltd. 2026. All rights reserved.
// This source file is part of the Cangjie project, licensed under Apache-2.0
// with Runtime Library Exception.
//
// See https://cangjie-lang.cn/pages/LICENSE for license information.

// EXEC: %compiler %local %f -Woff all -o %output
// RUN-EXEC: %run %run_opt %output %run_args

class C {
    public var value: Int64 = 0
    init() { value = 1 }
    init(this @local!) { exclave { value = 2 } }
    init(this @local?) { exclave { value = 3 } }
}

func heap(): C { C() }
func local(): C @local! { exclave { C() @local! } }
func maybe(): C @local? { exclave { C() @local? } }

class HalfClass {
    var fromHeap: C = heap()
    var fromLocal: C = local()
    var fromMaybe: C = maybe()
    var inferred = maybe()
    var fromCtor: C = C()
    init(this @local?) { exclave {} }
    init(this @local?, _: Int64) { exclave {} }
    static init() {}
    func sum(this @local?): Int64 {
        fromHeap.value + fromLocal.value + fromMaybe.value + inferred.value + fromCtor.value
    }
}

struct HalfStruct {
    var fromHeap: C = heap()
    var fromLocal: C = local()
    var fromMaybe: C = maybe()
    var inferred = maybe()
    var fromCtor: C = C()
    init(this @local?) { exclave {} }
    init(this @local?, _: Int64) { exclave {} }
    func sum(this @local?): Int64 {
        fromHeap.value + fromLocal.value + fromMaybe.value + inferred.value + fromCtor.value
    }
}

main(): Int64 {
    let c = HalfClass() @local?
    let s = HalfStruct() @local?
    let c2 = HalfClass(1) @local?
    let s2 = HalfStruct(1) @local?
    if (c.sum() != 12 || s.sum() != 12 || c2.sum() != 12 || s2.sum() != 12) {
        return 1
    }
    return 0
}
