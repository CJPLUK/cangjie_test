// Copyright (c) Huawei Technologies Co., Ltd. 2026. All rights reserved.
// This source file is part of the Cangjie project, licensed under Apache-2.0
// with Runtime Library Exception.
//
// See https://cangjie-lang.cn/pages/LICENSE for license information.

// EXEC: %compiler %local %f

func makeFull(): VArray<Int64, $2> @local! {
    VArray<Int64, $2> { i => i }
}

func sub() {
    let v: VArray<Int64, $2> @local! = makeFull()
    let x: Int64 @local! = v[0]
    let y: Int64 @local! = v[1]
}

main() {}
