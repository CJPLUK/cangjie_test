// Copyright (c) Huawei Technologies Co., Ltd. 2026. All rights reserved.
// This source file is part of the Cangjie project, licensed under Apache-2.0
// with Runtime Library Exception.
//
// See https://cangjie-lang.cn/pages/LICENSE for license information.

// LEVEL: 0
// EXEC: %mkdir tmps
// EXEC: %compiler -j1 %local %f %dumpCHIRDebug %save_temps_opt=tmps -Woff all -o %output
// RUN-EXEC: %run %run_opt %output
// EXEC: %llvmDissembler tmps/%n.bc
// EXEC: %cat copy_to_local_interface_CHIR/[0-9]*_SetMemoryRegion.chirtxt tmps/%n.ll | compare %f
// ASSERT: scan-4 StartRegion()
// ASSERT: scan-4 EndRegion()
// ASSERT: scan-4 call noalias i8 addrspace(1)* @llvm.cj.malloc.local.object(

interface I {
    func value(this @local?): Int64
}
struct S <: Copyable & I {
    let n: Int64
    init(n: Int64) { this.n = n }
    public func value(this @local?): Int64 { n }
}
func initFull(x: S): Int64 {
    let y: I @local! = x
    y.value()
}
func initHalf(x: S): Int64 {
    let y: I @local? = x
    y.value()
}
func acceptFull(x: I @local!): Int64 { x.value() }
func acceptHalf(x: I @local?): Int64 { x.value() }
func passFull(x: S): Int64 { acceptFull(x) }
func passHalf(x: S): Int64 { acceptHalf(x) }
main(): Int64 {
    let x = S(7)
    if (initFull(x) != 7 || initHalf(x) != 7 || passFull(x) != 7 || passHalf(x) != 7) { return 1 }
    0
}
