// Copyright (c) Huawei Technologies Co., Ltd. 2026. All rights reserved.
// This source file is part of the Cangjie project, licensed under Apache-2.0
// with Runtime Library Exception.
//
// See https://cangjie-lang.cn/pages/LICENSE for license information.

// LEVEL: 0
// DEPENDENCE: ../../pick_defination.py
// EXEC: %compiler %local %f %dumpCHIRDebug -Woff all -o %output
// RUN-EXEC: %run %run_opt %output
// EXEC: %python pick_defination.py copy_to_local_interface_wrapper_CHIR/[0-9]*_SetMemoryRegion.chirtxt "Func @_CVN7default1P3getHWlEv$N7default1PE$CN7default8ProducerE" | compare %f
// ASSERT: scan-not StartRegion()
// ASSERT: scan-not EndRegion()
// EXEC: %compiler %local %enableO2 %f -Woff all -o %output
// RUN-EXEC: %run %run_opt %output

interface I {
    func value(this @local?): Int64
}
struct S <: Copyable & I {
    public func value(this @local?): Int64 { 7 }
}
interface Producer {
    func get(this @local?): I @local?
}
struct P <: Copyable & Producer {
    public func get(this @local?): I @local? { exclave { S() } }
}
func consume(p: Producer @local?): Int64 { p.get().value() }
main(): Int64 {
    let p: Producer @local? = P()
    if (consume(p) != 7) { return 1 }
    0
}
