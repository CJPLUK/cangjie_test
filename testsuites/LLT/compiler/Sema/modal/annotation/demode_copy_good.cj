// Copyright (c) Huawei Technologies Co., Ltd. 2026. All rights reserved.
// This source file is part of the Cangjie project, licensed under Apache-2.0
// with Runtime Library Exception.
//
// See https://cangjie-lang.cn/pages/LICENSE for license information.

// EXEC: %compiler %local %f -o %output
// RUN-EXEC: %run %run_opt %output %run_args

struct Point <: Copyable {
    let x: Int64 = 0
    let y: Int64 = 0
    init() {}
}

struct Segment <: Copyable {
    demode let start: Point = Point()
    demode let end: Point = Point()
    init() {}
}

class Holder {
    demode var seg: Segment
    init() { seg = Segment() }
    init(this @local!) { exclave { seg = Segment() } }
}

func copyFieldLocked() {
    var h: Holder@local! = Holder()@local!
    let s: Segment = h.seg
    let p: Point = s.start
    let _: Int64 = p.x + s.end.y
}

func assignCopyField() {
    var h: Holder@local! = Holder()
    var s: Segment = Segment()
    h.seg = s
}

main(): Unit {
    copyFieldLocked()
    assignCopyField()
}
