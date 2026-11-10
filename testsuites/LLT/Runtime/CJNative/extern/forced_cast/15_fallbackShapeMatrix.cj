// Copyright (c) Huawei Technologies Co., Ltd. 2025. All rights reserved.
// This source file is part of the Cangjie project, licensed under Apache-2.0
// with Runtime Library Exception.
//
// See https://cangjie-lang.cn/pages/LICENSE for license information.

// EXEC-0: %compiler %cmp_opt %f -o %output
// RUN-EXEC: %run %run_opt %output %run_args

// Coverage completion for the non-forced-cast (fallback) direction across `U` shapes
// and operand forms not exercised elsewhere. None of these are forced casts (the
// operand is never Extern); they round out the matrix so every viable callee shape /
// operand form is guarded, not only the ones that once misbehaved:
//   * generic function call   `(genId<Int64>)(x)`
//   * generic constructor     `(Box<Int64>)(x)`   (operand not Extern -> construct)
//   * unit operand, function  `(zero)()`
//   * unit operand, constructor `(NoArg)()`
// (Simple names live in 02/04, qualified/dotted in 14, generic FC targets in 05.)

class Box<T> {
    let value: T
    public init(value: T) { this.value = value }
}

class NoArg {
    let tag: Int64
    public init() { this.tag = 7 }
}

func genId<T>(x: T): T { x }

func zero(): Int64 { 42 }

main() {
    let genericCall = (genId<Int64>)(5)
    let genericCtor = (Box<Int64>)(9)
    let unitCall = (zero)()
    let unitCtor = (NoArg)()

    if (genericCall != 5 || genericCtor.value != 9 || unitCall != 42 || unitCtor.tag != 7) {
        throw Exception("fallback shape matrix failed")
    }
}
