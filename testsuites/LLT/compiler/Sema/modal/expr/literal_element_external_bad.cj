// Copyright (c) Huawei Technologies Co., Ltd. 2026. All rights reserved.
// This source file is part of the Cangjie project, licensed under Apache-2.0
// with Runtime Library Exception.
//
// See https://cangjie-lang.cn/pages/LICENSE for license information.

// EXEC-PIPE-1: %compiler %local %diag_json %f 2>&1 | compare %f

class C {
    public init() {}
}

struct P {
    var x: Int64 = 0
    init() {}
}

@C
struct S {}

func arrayInterface(a: C @local!) {
    let x: Collection<C> @local! = [a]
}

func arrayInterfaceCopy(a: S @local!) {
    let y: Collection<S> @local! = [a]
}

func arrayBoxedToAny(a: C @local!) {
    let y: Any @local! = [a]
}

func tupleCovariant(a: S @local!) {
    let z: (Any, Any) @local! = (a, a)
}

func tupleOption(a: C @local!) {
    let z: ?(C, C) @local! = (a, a)
}

func tupleBoxedToAny(a: C @local!) {
    let z: Any @local! = (a, a)
}

func varrayInit(a: P @local!) {
    let w: VArray<P, $2> @local! = [a, a]
}

main() {}

// ASSERT: scan-7 "DiagKind": "sema_bad_local_assignment",
// ASSERT: scan "Errors": 7,
