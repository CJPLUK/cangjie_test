// Copyright (c) Huawei Technologies Co., Ltd. 2026. All rights reserved.
// This source file is part of the Cangjie project, licensed under Apache-2.0
// with Runtime Library Exception.
//
// See https://cangjie-lang.cn/pages/LICENSE for license information.

// EXEC: %compiler %local %cmp_opt %f -o %output
// RUN-EXEC: %run %run_opt %output %run_args
// TODO: DCE location error
class Box {
    var x: Int = 0
    init() {}
    init(this @local!) {
        exclave { }
    }
}

func makeLocal(val: Int): Box @local! {
    return exclave {
        let b: Box @local! = Box()
        b.x = val
        b
    }
}

main(): Int {
    let a = makeLocal(7)
    if (a.x == 7) {
        0
    } else {
        1
    }
}
