// Copyright (c) Huawei Technologies Co., Ltd. 2026. All rights reserved.
// This source file is part of the Cangjie project, licensed under Apache-2.0
// with Runtime Library Exception.
//
// See https://cangjie-lang.cn/pages/LICENSE for license information.

// EXEC: %compiler %local %f

func ints(xs: Array<Int64> @local!) {
    let v: Array<Int64> @local? = xs
    v[0]
    let x = v[0]
    v.size
    for (x in v) {}
}
func strings(xs: Array<String> @local!) {
    let v: Array<String> @local? = xs
    v[0]
    let x = v[0]
    v.size
    for (x in v) {}
}
main() {}
