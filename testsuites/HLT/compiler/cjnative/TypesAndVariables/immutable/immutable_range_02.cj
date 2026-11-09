/*
 * Copyright (c) Huawei Technologies Co., Ltd. 2025. All rights reserved.
 * This source file is part of the Cangjie project, licensed under Apache-2.0
 * with Runtime Library Exception.
 * 
 * See https://cangjie-lang.cn/pages/LICENSE for license information.
 */

// LEVEL: 1
// EXEC: %compiler %cmp_opt %f -o %output
// RUN-EXEC: %run %run_opt %output %run_args

main(): Int64 {
    var a1: Range<Aoo> = (Aoo(1)..Aoo(2) : 1)
    return 0
}

struct Coo {
    public var a: Int32 = 1
    public let b: Int32 = 1
    public init(x: Int32) {
        a = x
    }
}

class Aoo {
    public var a: Int32 = 1
    public let b: Int32 = 1
    public init(x: Int32) {
        a = x
    }
}

extend Aoo <: Countable<Aoo> & Comparable<Aoo> {
    public func compare(rhs: Aoo): Ordering {
        match {
            case this.a < rhs.a => Ordering.LT
            case this.a > rhs.a => Ordering.GT
            case _ => Ordering.EQ
        }
    }
    public func next(right: Int64): Aoo {
        this
    }
    public func position(): Int64 {
        return Int64(this.a)
    }
    public operator func +(right: Aoo): Int32 {
        return right.a + this.a
    }
    public operator func !=(right: Aoo): Bool {
        return true
    }
    public operator func ==(right: Aoo): Bool {
        return true
    }
    public operator func <(right: Aoo): Bool {
        return false
    }
    public operator func <=(right: Aoo): Bool {
        return false
    }
    public operator func >(right: Aoo): Bool {
        return false
    }
    public operator func >=(right: Aoo): Bool {
        return false
    }
}

extend Coo <: Countable<Coo> & Comparable<Coo> {
    public func compare(rhs: Coo): Ordering {
        match {
            case this.a < rhs.a => Ordering.LT
            case this.a > rhs.a => Ordering.GT
            case _ => Ordering.EQ
        }
    }
    public func next(right: Int64): Coo {
        this
    }
    public func position(): Int64 {
        return Int64(this.a)
    }
    public operator func +(right: Coo): Int32 {
        return right.a + this.a
    }
    public operator func !=(right: Coo): Bool {
        return true
    }
    public operator func ==(right: Coo): Bool {
        return true
    }
    public operator func <(right: Coo): Bool {
        return false
    }
    public operator func <=(right: Coo): Bool {
        return false
    }
    public operator func >(right: Coo): Bool {
        return false
    }
    public operator func >=(right: Coo): Bool {
        return false
    }
}
