/*
 * Copyright (c) Huawei Technologies Co., Ltd. 2026. All rights reserved.
 * This source file is part of the Cangjie project, licensed under Apache-2.0
 * with Runtime Library Exception.
 *
 * See https://cangjie-lang.cn/pages/LICENSE for license information.
 */

// COV-056: error paths of the type-contract parser and validator:
// malformed clauses, `extend` type-level clauses that are rejected, abstract
// variable name clashes, and `@ghost` checks in constructors.
// EXEC-PIPE-1: %compiler %import-cangjie-stdx %cmp_opt %f -o %output 2>&1 | compare %f
// ASSERT: scan variable clause needs a name and `:` before its type
// ASSERT: scan contract clause needs a type
// ASSERT: scan cannot have an invariant visibility selector
// ASSERT: scan expected `invariant` in type contract
// ASSERT: scan `inherits` clause needs `from` or `invariant`
// ASSERT: scan `inherits invariant` needs `<type>.<name>`
// ASSERT: scan supports only the `[conforming]` modifier
// ASSERT: scan `$pre` is not supported in `invariant` conditions
// ASSERT: scan expected a type contract clause, got bogus
// ASSERT: scan extend type-level contracts cannot declare or inherit invariants
// ASSERT: scan extend contracts cannot use selective `inherits invariant`
// ASSERT: scan conflicts with an existing member of the same name
// ASSERT: scan member function calls are not allowed in `@ghost` blocks of constructors
// ASSERT: scan is read in `@ghost` before it is initialized
// ASSERT: scan-not core dumped

import stdx.contract.macros.*

// Malformed `variable` clause: missing `:`.
@Contract[
    variable bad
]
class CovNegType01A {
    public init() {}
}

// Malformed `variable` clause: missing type.
@Contract[
    variable v:
]
class CovNegType01B {
    public init() {}
}

// Malformed `variable` clause: missing name.
@Contract[
    variable 1: Int64
]
class CovNegType01C {
    public init() {}
}

// `variable` cannot carry an invariant visibility selector.
@Contract[
    on_public variable v: Int64 = 0
]
class CovNegType01D {
    public init() {}
}

// `@Contract[static]` on a type needs an `invariant` clause.
@Contract[
    static
]
class CovNegType01E {
    public init() {}
}

// `inherits` with nothing after it.
@Contract[
    inherits
]
class CovNegType01F {
    public init() {}
}

// `inherits` with an unexpected keyword after it.
@Contract[
    inherits wat
]
class CovNegType01G {
    public init() {}
}

// `inherits invariant` without a member reference.
@Contract[
    inherits invariant junk
]
class CovNegType01H {
    public init() {}
}

// `inherits invariant rename = <not a member reference>`.
@Contract[
    inherits invariant X = junk
]
class CovNegType01I {
    public init() {}
}

// Member reference with a leading dot is not a `<type>.<name>`.
@Contract[
    inherits invariant .I1
]
class CovNegType01J {
    public init() {}
}

// The part before the dot is not type-like.
@Contract[
    inherits invariant 1.I1
]
class CovNegType01K {
    public init() {}
}

// The part before the dot does not parse as a type.
@Contract[
    inherits invariant f(x).y
]
class CovNegType01L {
    public init() {}
}

// `inherits from T [x]` supports only `[conforming]`.
@Contract[
    inherits from CovNegType01A [bogus]
]
class CovNegType01M <: CovNegType01A {
    public init() {}
}

// `$pre` is only defined for `ensures`.
@Contract[
    invariant $pre > 0
]
class CovNegType01N {
    public init() {}
}

// Unknown type-level clause.
@Contract[
    bogus
]
class CovNegType01O {
    public init() {}
}

// A trailing separator at the end of the type contract.
@Contract[
    invariant true,
]
class CovNegType01P {
    public init() {}
}

// `extend` cannot declare a type-level invariant.
@Contract[
    invariant true
]
extend CovNegType01A {
}

open class CovNegType01Host {
    public init() {}
}

// `extend` cannot use a selective `inherits invariant`.
@Contract[
    inherits invariant CovNegType01Host.I1
]
extend CovNegType01Host {
}

// Abstract variable name clashes with an existing member.
@Contract[
    variable p: Int64
]
class CovNegType01Q {
    public var p: Int64 = 0

    public init() {}
}

// A member function may not be called from a constructor `@ghost` block.
@Contract[
    variable aux: Int64
]
class CovNegType01R {
    func helper(): Unit {}

    func helperG<T>(x: T): Unit {}

    init() {
        @ghost(
            helper()
            this.helper()
            helperG<Int64>(1)
            aux = 1
        )
    }
}

// Reading an uninitialized abstract variable in `@ghost` is reported.
@Contract[
    variable aux2: Int64
]
class CovNegType01S {
    init() {
        @ghost(
            println(aux2)
            aux2 = 1
        )
    }
}

main() {
}
