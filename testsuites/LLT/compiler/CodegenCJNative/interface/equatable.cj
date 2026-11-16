// Copyright (c) Huawei Technologies Co., Ltd. 2025. All rights reserved.
// This source file is part of the Cangjie project, licensed under Apache-2.0
// with Runtime Library Exception.
//
// See https://cangjie-lang.cn/pages/LICENSE for license information.

// EXEC-PIPE-1: %compiler %cmp_opt %n.cj -o %n.%suffix 2>&1 | compare %f

import std.collection.*

open class A {
    let id: Int32
    var param: ArrayList<B> = ArrayList<B>()
    init() {
        id = 0
    }
    func isMA(a: A, b: A): Bool {
        return a == b
    }
}

extend A <: Equatable<A> & Hashable {
    operator func ==(rhs: A): Bool {
        this.id == rhs.id
    }
    operator func !=(rhs: A): Bool {
        this.id != rhs.id
    }
    func hashCode(): Int64 {
        Int64(this.id)
    }
}

class B <: A {
    operator func ==(rhs: B): Bool {
        this.id == rhs.id
    }
    operator func !=(rhs: B): Bool {
        this.id != rhs.id
    }

    init() {
    }
}

main() {
    0
}

// Match the diagnostic contract independently of standard-library source positions.
// ASSERT: regex error: a deriving member must be at least as visible as its base member
// ASSERT: regex '!=' is inherited
// ASSERT: regex note: the deriving '!=' is defined here
// ASSERT: regex the visibility of the deriving '!=' is 'internal'
// ASSERT: regex note: the visibility of the base '!=' is 'public'
// ASSERT: regex 1 error generated, 1 error printed\.
