// Copyright (c) Huawei Technologies Co., Ltd. 2026. All rights reserved.
// This source file is part of the Cangjie project, licensed under Apache-2.0
// with Runtime Library Exception.
//
// See https://cangjie-lang.cn/pages/LICENSE for license information.

// Upper bound member lookup must not distinguish candidates by return type: two bounds that
// declare the same parameter signature with covariant return types (Base / Sub) are one
// signature, so `t.get()` under `where T <: I1 & I2` must not become ambiguous. Comparing the
// return type is only needed for sum member lookup, where a member's return type does take part
// in the signature.

// EXEC: %compiler %local %cmp_opt %f -Woff all -o %output

open class Base {}
class Sub <: Base {}

interface I1 {
    func get(): Base
}

interface I2 {
    func get(): Sub
}

class Impl <: I1 & I2 {
    public func get(): Sub {
        Sub()
    }
}

func use<T>(t: T) where T <: I1 & I2 {
    let x: Base = t.get()
}

main() {}
