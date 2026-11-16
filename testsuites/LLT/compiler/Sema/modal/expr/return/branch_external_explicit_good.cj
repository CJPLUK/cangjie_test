// Copyright (c) Huawei Technologies Co., Ltd. 2026. All rights reserved.
// This source file is part of the Cangjie project, licensed under Apache-2.0
// with Runtime Library Exception.
//
// See https://cangjie-lang.cn/pages/LICENSE for license information.

// Each branch explicitly returns an external @local! parameter, which is allowed.

// EXEC: %compiler %local %f -o %output

func ifReturn(c: Bool, a: String @local!, b: String @local!): String @local! {
    if (c) { return a } else { return b }
}

func matchReturn(n: Int64, a: String @local!, b: String @local!): String @local! {
    match (n) {
        case 0 => return a
        case _ => return b
    }
}

func tryReturn(a: String @local!, b: String @local!): String @local! {
    try { return a } catch (_: Exception) { return b }
}

main() {}
