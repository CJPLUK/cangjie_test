// Copyright (c) Huawei Technologies Co., Ltd. 2026. All rights reserved.
// This source file is part of the Cangjie project, licensed under Apache-2.0
// with Runtime Library Exception.
//
// See https://cangjie-lang.cn/pages/LICENSE for license information.

// LEVEL: 0
// DEPENDENCE: ../pick_defination.py
// EXEC: %compiler %local %n.cj %dumpCHIRDebug -Woff unused -o %output
// EXEC-PIPE-0: %run %output
// EXEC: %python pick_defination.py virtual_method_wrapper_local_array_CHIR/[0-9]*_SetMemoryRegion.chirtxt "Func @_CVN7default11LocalSource7toArrayHWlEv$N7default11LocalSourceE$CN7default6SourceIG_El" | compare %f
// ASSERT: scan-not StartRegion()
// ASSERT: scan-not EndRegion()
// EXEC: %compiler %local %n.cj %enableO2 -o %output
// EXEC-PIPE-0: %run %output

// Generic interface virtual dispatch goes through a wrapper that Boxes the
// `Array<T> @local?` result. The wrapper must not open its own region, or
// EndRegion reclaims the array backing store before the caller reads it.
interface Source<T> {
    func toArray(this @local?): Array<T> @local?
}

class LocalSource <: Source<Int64> {
    public func toArray(this @local?): Array<Int64> @local? {
        exclave {
            let r: Array<Int64> @local! = Array<Int64>(2, repeat: 7)
            r[1] = 8
            r
        }
    }
}

class Bag {
    let sum: Int64
    let first: Int64
    public exclave init(this @local?, src: Source<Int64> @local?) {
        let got: Array<Int64> @local? = src.toArray()
        var s = 0
        var i = 0
        while (i < got.size) {
            s = s + got[i]
            i++
        }
        sum = s
        first = got[0]
    }
}

main(): Int64 {
    let src: Source<Int64> @local? = LocalSource()
    let bag: Bag @local? = Bag(src) @local?
    if (bag.first == 7 && bag.sum == 15) {
        return 0
    }
    return 1
}
