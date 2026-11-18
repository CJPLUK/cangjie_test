// Copyright (c) Huawei Technologies Co., Ltd. 2026. All rights reserved.
// This source file is part of the Cangjie project, licensed under Apache-2.0
// with Runtime Library Exception.
//
// See https://cangjie-lang.cn/pages/LICENSE for license information.

// RUN-EXEC-PIPE-1: %compiler %cmp_opt --error-count-limit all %f -o %output 2>&1 | compare %f
// ASSERT: scan-9 can not instantiate 'Generics-T' by 'Nothing' for it has unimplemented static member
// ASSERT: scan-1 type incompatible in this assignment
// ASSERT: scan-1 10 errors generated
// ASSERT: scan-not Internal Compiler Error

// Nothing satisfies the constraint of Extern<T>, but it has no static function toExtern for the conversion to
// Extern<Nothing>. As for a struct whose type parameter has static members, no value of type Extern<Nothing> can be
// created.

func argument(e: Extern<Nothing>): Unit {}

func result(): Extern<Nothing> {
    return 1
}

func implicitResult(): Extern<Nothing> {
    1
}

func coalesce(o: ?Extern<Nothing>): Extern<Nothing> {
    o ?? 1
}

main() {
    let _: Extern<Nothing> = 1
    var e: Extern<Nothing> = 1
    e = "a"
    argument(1)
    let _: Array<Extern<Nothing>> = [1]
    let _: (Extern<Nothing>, Int64) = (1, 2)
    0
}
