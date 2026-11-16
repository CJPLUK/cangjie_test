// Copyright (c) Huawei Technologies Co., Ltd. 2026. All rights reserved.
// This source file is part of the Cangjie project, licensed under Apache-2.0
// with Runtime Library Exception.
//
// See https://cangjie-lang.cn/pages/LICENSE for license information.

// LEVEL: 0
// DEPENDENCE: ../pick_defination.py
// EXEC: %compiler %local %n.cj %dumpCHIRDebug -Woff unused -o %output
// EXEC-PIPE-0: %run %output
// EXEC: %python pick_defination.py mut_function_wrapper_local_return_CHIR/[0-9]*_SetMemoryRegion.chirtxt "Func @_CMN7default5Maker4makeHv$N7default6HolderE$CN7default5MakerE" | compare %f
// ASSERT: scan-not StartRegion()
// ASSERT: scan-not EndRegion()
// EXEC: %compiler %local %n.cj %enableO2 -o %output
// EXEC-PIPE-0: %run %output

// A struct inheriting an interface's `mut` default implementation gets a mut
// function wrapper. The wrapper forwards through an Apply whose result is
// `Payload @local?`, so it must not open its own region, or EndRegion reclaims
// the payload before the caller reads it.
class Payload {
    var v: Int64
    public exclave init(this @local?, n: Int64) {
        v = n
    }
}

interface Maker {
    mut func make(): Payload @local? {
        exclave {
            build()
        }
    }
    mut func build(): Payload @local?
}

struct Holder <: Maker {
    var seed: Int64 = 7
    public mut func build(): Payload @local? {
        seed = seed + 1
        return exclave { Payload(seed) @local? }
    }
}

main(): Int64 {
    var h = Holder()
    let p: Payload @local? = h.make()
    if (p.v == 8 && h.seed == 8) {
        return 0
    }
    return 1
}
