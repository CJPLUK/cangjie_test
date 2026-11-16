// Copyright (c) Huawei Technologies Co., Ltd. 2026. All rights reserved.
// This source file is part of the Cangjie project, licensed under Apache-2.0
// with Runtime Library Exception.
//
// See https://cangjie-lang.cn/pages/LICENSE for license information.

// DEPENDENCE: pkg_nested_exports.cj
// EXEC: %compiler %local %compile_lib_opt pkg_nested_exports.cj -o pkg_nested_exports.%middle
// EXEC: %compiler %local pkg_nested_exports.%middle %f

import pkg_nested_exports.*
main() {
    let f = Exports.fullCallback
    let h = Exports.halfCallback
    let g = makeFull()
    let k = makeHalf()
    let x = f(g(1)) + h(k(2))
}
