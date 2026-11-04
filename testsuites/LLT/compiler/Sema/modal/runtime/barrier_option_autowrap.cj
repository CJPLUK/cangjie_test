// Copyright (c) Huawei Technologies Co., Ltd. 2026. All rights reserved.
// This source file is part of the Cangjie project, licensed under Apache-2.0
// with Runtime Library Exception.
//
// See https://cangjie-lang.cn/pages/LICENSE for license information.

// EXEC: %compiler %local %f -o %output --apc=1
// EXEC: %run %run_opt %output %run_args

interface Adapt<T> {
    static func fromV(): T @local!
}

extend Int64 <: Adapt<Int64> {
    public static func fromV(): Int64 @local! { 1 }
}

extend<T> Option<T> where T <: Adapt<T> {
    public static exclave func fromV(): Option<T> @local! {
        return T.fromV()
    }
}

main() {
    let _ = Option<Int64>.fromV()
}
