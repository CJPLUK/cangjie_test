/*
 * Copyright (c) Huawei Technologies Co., Ltd. 2025. All rights reserved.
 * This source file is part of the Cangjie project, licensed under Apache-2.0
 * with Runtime Library Exception.
 * 
 * See https://cangjie-lang.cn/pages/LICENSE for license information.
 */

 package rcon

import rcont.*

public class CPlain {
    public var iv0: Int64 = 0
    public var iv1: String = "a"

    public static var sv0: Bool = false

    public prop pr0: String {
        get() {
            "r"
        }
    }

    public mut prop pm0: Int64 {
        get() {
            0
        }
        set(v) {
            this.iv0 = v
        }
    }

    public static prop sp0: Float64 {
        get() {
            1.0
        }
    }

    public init() {}

    public init(a: Bool, b: Rune) {}

    public init(a: Int64) {}

    public init(a: Int64, b: String, c: Int64, d: String) {}

    public func fa(): Unit {}

    public func fb(a: Int64, b: Bool): Int64 {
        0
    }

    public func fc(a: String): String {
        a
    }
}

public open class COpen {
    public mut prop om: Int64 {
        get() {
            0
        }
        set(v) {}
    }
    public var ov: Int64 = 0

    public func of0(): Unit {}
}

public abstract class CAb {
    public mut prop apr: Int64
    public func af(a: Int64): Unit

    public const init() {}
}

public interface IAb {
    func if0(): Unit
    mut prop ipm: Int8
    prop ipr: Int64 {
        get() {
            1
        }
    }
    static func isf(a: Int64, b: Bool): Int16
    static prop isp: Int64 {
        get() {
            2
        }
    }
}

public class CG<A, B> {
    public let va: A
    public let vb: B
    public init(a: A, b: B) {
        this.va = a
        this.vb = b
    }
}

public class CG2<T> {
    public let vt: T
    public init(t: T) {
        this.vt = t
    }
}

public struct SG<T> {
    public let vt: T
    public init(t: T) {
        this.vt = t
    }
}

public func g0(u: Unit): Unit {}

public func g1(a: Int8, b: Int16, c: Int32, d: Int64): IntNative {
    0
}

public func g2(a: UInt8, b: UInt16, c: UInt32, d: UInt64): UIntNative {
    0
}

public func g3(a: Float16, b: Float32, c: Float64): Rune {
    r'z'
}

public func g4(u: Unit, c: C1, s: S1, b: Bool): String {
    "g4"
}

public let gv0: C1 = C1()
public let gv1: Any = "any"
public let gv2: Object = C1()
public let gv3: Bool = false
