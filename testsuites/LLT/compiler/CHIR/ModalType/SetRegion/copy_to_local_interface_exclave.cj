// Copyright (c) Huawei Technologies Co., Ltd. 2026. All rights reserved.
// This source file is part of the Cangjie project, licensed under Apache-2.0
// with Runtime Library Exception.
//
// See https://cangjie-lang.cn/pages/LICENSE for license information.

// LEVEL: 0
// EXEC: %compiler %local %f %dumpCHIRDebug -Woff all -o %output
// RUN-EXEC: %run %run_opt %output
// DEPENDENCE: ../../pick_defination.py
// EXEC: %python pick_defination.py copy_to_local_interface_exclave_CHIR/[0-9]*_SetMemoryRegion.chirtxt "Func @_CN7default4fullH" | compare %f
// EXEC: %python pick_defination.py copy_to_local_interface_exclave_CHIR/[0-9]*_SetMemoryRegion.chirtxt "Func @_CN7default4halfH" | compare %f
// EXEC: %python pick_defination.py copy_to_local_interface_exclave_CHIR/[0-9]*_SetMemoryRegion.chirtxt "Func @_CN7default12optionalFullH" | compare %f
// EXEC: %python pick_defination.py copy_to_local_interface_exclave_CHIR/[0-9]*_SetMemoryRegion.chirtxt "Func @_CN7default12optionalHalfH" | compare %f
// EXEC: %python pick_defination.py copy_to_local_interface_exclave_CHIR/[0-9]*_SetMemoryRegion.chirtxt "Func @_CN7default10nestedFullH" | compare %f
// EXEC: %python pick_defination.py copy_to_local_interface_exclave_CHIR/[0-9]*_SetMemoryRegion.chirtxt "Func @_CN7default10nestedHalfH" | compare %f
// EXEC: %python pick_defination.py copy_to_local_interface_exclave_CHIR/[0-9]*_SetMemoryRegion.chirtxt "Func @_CN7default9blockFullH" | compare %f
// EXEC: %python pick_defination.py copy_to_local_interface_exclave_CHIR/[0-9]*_SetMemoryRegion.chirtxt "Func @_CN7default9blockHalfH" | compare %f
// ASSERT: scan-not StartRegion()
// ASSERT: scan-not EndRegion()

interface I {
    func value(this @local?): Int64
}
struct S <: Copyable & I {
    let n: Int64
    init(n: Int64) { this.n = n }
    public func value(this @local?): Int64 { n }
}
exclave func full(x: S): I @local! { x }
exclave func half(x: S): I @local? { x }
exclave func optionalFull(x: S): ?I @local! { x }
exclave func optionalHalf(x: S): ?I @local? { x }
exclave func nestedFull(x: S): ??I @local! { x }
exclave func nestedHalf(x: S): ??I @local? { x }
func blockFull(x: S): I @local! { exclave { x } }
func blockHalf(x: S): I @local? { exclave { x } }
func read(x: ?I @local?): Int64 {
    match (x) {
        case Some(v) => v.value()
        case None => -1
    }
}
func readNested(x: ??I @local?): Int64 {
    match (x) {
        case Some(v) => read(v)
        case None => -1
    }
}
main(): Int64 {
    let x = S(7)
    if (full(x).value() != 7 || half(x).value() != 7 || blockFull(x).value() != 7 ||
        blockHalf(x).value() != 7 || read(optionalFull(x)) != 7 || read(optionalHalf(x)) != 7 ||
        readNested(nestedFull(x)) != 7 || readNested(nestedHalf(x)) != 7) { return 1 }
    0
}
