// Copyright (c) Huawei Technologies Co., Ltd. 2026. All rights reserved.
// This source file is part of the Cangjie project, licensed under Apache-2.0
// with Runtime Library Exception.
//
// See https://cangjie-lang.cn/pages/LICENSE for license information.

// ERRCHECK: %compiler %local %f -Woff all %diag_json 2>&1

struct Dem<T> {
    demode var v: T
    init(a: T) {
        v = a 
    }
    exclave init(this @local!, a: T) {
        v = a
    }
}
interface I<T> {
    mut prop x: String @local!
    prop car: Dem<()->T> @local!
}

func foo<T>(value: T) where T <: I<String> {
    let str = value.x.size
    value.x = value.car()
    let b = value.car().size
    str.size - b.size
}

main() {}
// ASSERT: scan-1 "DiagKind": "sema_cannot_assign_to_immutable",
// ASSERT: scan-3 "DiagKind": "sema_no_match_prop_accessor_for_call",
// ASSERT: scan "Errors": 4,