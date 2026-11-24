// Copyright (c) Huawei Technologies Co., Ltd. 2026. All rights reserved.
// This source file is part of the Cangjie project, licensed under Apache-2.0
// with Runtime Library Exception.
//
// See https://cangjie-lang.cn/pages/LICENSE for license information.

// LEVEL: 0
// EXEC: %compiler %local %f %dumpCHIRDebug -Woff all -o %output
// RUN-EXEC: %run %run_opt %output
// EXEC: %cat copy_to_heap_interface_CHIR/[0-9]*_SetMemoryRegion.chirtxt | compare %f
// ASSERT: scan-not StartRegion()
// ASSERT: scan-not EndRegion()

interface I {
    func value(): Int64
}
struct S <: Copyable & I {
    let n: Int64
    init(n: Int64) { this.n = n }
    public func value(): Int64 { n }
}
func take(x: I): Int64 { x.value() }
func initFull(x: S @local!): Int64 {
    let y: I = x
    y.value()
}
func initHalf(x: S @local?): Int64 {
    let y: I = x
    y.value()
}
func assignFull(x: S @local!, y: I): Int64 {
    var z = y
    z = x
    z.value()
}
func assignHalf(x: S @local?, y: I): Int64 {
    var z = y
    z = x
    z.value()
}
func passFull(x: S @local!): Int64 { take(x) }
func passHalf(x: S @local?): Int64 { take(x) }
func heap(x: S): I { x }
main(): Int64 {
    let x: S @local! = S(7)
    let y: S @local? = S(7)
    let z: I = S(0)
    if (initFull(x) != 7 || initHalf(y) != 7 || assignFull(x, z) != 7 || assignHalf(y, z) != 7 ||
        passFull(x) != 7 || passHalf(y) != 7 || heap(S(7)).value() != 7) { return 1 }
    0
}
