// Copyright (c) Huawei Technologies Co., Ltd. 2026. All rights reserved.
// This source file is part of the Cangjie project, licensed under Apache-2.0
// with Runtime Library Exception.
//
// See https://cangjie-lang.cn/pages/LICENSE for license information.

// EXEC: %compiler %local %f -o %output --apc=1
// EXEC: %run %run_opt %output %run_args | compare %f

interface ToJV<T> {
    func toJV(this @local!): Unit
}

extend String <: ToJV<String> {
    public exclave func toJV(this @local!): Unit {}
}

exclave func dump<V>(o: Option<V> @local!): Unit where V <: ToJV<V> {
    if (let Some(item) <- o) {
        item.toJV()
    }
}

main(): Int64 {
    let o: Option<String> @local! = Option<String>.Some("")
    dump(o)
    println("ok")
    0
}

/* SCAN
ok
*/
