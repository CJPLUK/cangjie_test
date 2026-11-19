// Copyright (c) Huawei Technologies Co., Ltd. 2026. All rights reserved.
// This source file is part of the Cangjie project, licensed under Apache-2.0
// with Runtime library Exception.
//
// See https://cangjie-lang.cn/pages/LICENSE for license information.

// LEVEL: 0

// SEPARATE-FILE: c/c.cj
// EXEC-0: %compiler %noColor --experimental c/c.cj --output-type=chir --output-dir ./c
package cmp

public interface Iface {
    func who(): Int64
}

public struct Impl1 <: Iface {
    public func who(): Int64 {
        return 1
    }
}

public struct Impl2 <: Iface {
    public var a: Int64 = 0

    public func who(): Int64 {
        return 2
    }
}

public common class Holder {
    public common var value: Iface = Impl1()

    public common init() {
    }

    public common func get(): Int64
}

// SEPARATE-FILE: p1/p1.cj
// EXEC-0: %compiler %noColor --experimental p1/p1.cj --common-part-chir=./c/cmp.chir --common-part-cjo=./c/cmp.cjo --output-dir=./p1 --output-type=chir
package cmp

public specific class Holder {
    public specific var value: Iface = Impl2()

    public specific init() {
    }

    public specific func get(): Int64 {
        return value.who()
    }
}

// SEPARATE-FILE: p2/p2.cj
// EXEC-0: %compiler %noColor --experimental p2/p2.cj --common-part-chir=./p1/cmp.chir --common-part-cjo=./p1/cmp.cjo --output-type=dylib
package cmp

public specific class Holder {
    public specific init() {
    }

    public specific func get(): Int64 {
        return value.who()
    }
}

// SEPARATE-FILE: main.cj
// EXEC-0: %compiler %noColor main.cj -lcmp -L. -o %output
// RUN: %run %output 2>&1 | compare %f
import cmp.*

main(): Unit {
    println(Holder().get())
}

/*SCAN
2
*/
