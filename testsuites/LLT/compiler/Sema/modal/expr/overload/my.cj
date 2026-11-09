// Copyright (c) Huawei Technologies Co., Ltd. 2026. All rights reserved.
// This source file is part of the Cangjie project, licensed under Apache-2.0
// with Runtime Library Exception.
//
// See https://cangjie-lang.cn/pages/LICENSE for license information.

// EXEC: %compiler %local %f -o %output
// EXEC: %run %run_opt %output %run_args

class C<R> {
    public func setAtIndex(this @local?, value: R@local?): Unit {
    }
}

main() {
    let arr = C<UInt8>()
    arr.setAtIndex(UInt8(10))
}