// Copyright (c) Huawei Technologies Co., Ltd. 2026. All rights reserved.
// This source file is part of the Cangjie project, licensed under Apache-2.0
// with Runtime Library Exception.
//
// See https://cangjie-lang.cn/pages/LICENSE for license information.

// DEPENDENCE: ../macro/identity.macro.cj
// EXEC: %compiler %local %cmp_macro identity.macro.cj
// EXEC: %compiler %local %f

import identity_macro.*

@Identity
main() {
    let a: String @local!= "hello"
    let b: String @local?= "hello"
}
