// Copyright (c) Huawei Technologies Co., Ltd. 2026. All rights reserved.
// This source file is part of the Cangjie project, licensed under Apache-2.0
// with Runtime Library Exception.
//
// See https://cangjie-lang.cn/pages/LICENSE for license information.

// The ideal state kept for a literal in the implicit-return position of a lambda that is a direct
// argument of a generic call covers the modal as well as the type: a non-copy literal keeps a
// pending modal until generic type argument inference resolves it. When the callee's formal is the
// type variable itself, the lambda's own inferred type becomes the type argument and carries that
// pending modal in its return type. An unresolved modal has to default to ~local, so the lambda is
// usable as a plain () -> String value; leaving it pending is reported as an internal @ideal mode.

// EXEC: %compiler %local %cmp_opt %f -Woff all -o %output
// EXEC: %run %run_opt %output | compare %f

class Holder<T> {
    let get: T
    init(x: T) { get = x }
}

func id<T>(x: T): T { x }

main() {
    // Non-copy literal through a generic class constructor.
    let holder = Holder({=> "holder"})
    let s: String = holder.get()
    println(s)
    // Non-copy literal through a generic function, assigned to a plain function type.
    let g: () -> String = id({=> "id"})
    let t: String = g()
    println(t)
    return 0
}

/* SCAN
holder
id
*/
