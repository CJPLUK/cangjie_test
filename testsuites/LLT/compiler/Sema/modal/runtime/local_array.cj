// Copyright (c) Huawei Technologies Co., Ltd. 2026. All rights reserved.
// This source file is part of the Cangjie project, licensed under Apache-2.0
// with Runtime Library Exception.
//
// See https://cangjie-lang.cn/pages/LICENSE for license information.

// EXEC: %compiler %local %f -o %output -O2
// EXEC: %run %run_opt %output %run_args

class Box {
    public init() {}
    public exclave init(this @local!) {}
}

main() {
    let _: String @local! = crash()
}

exclave func crash(): String @local! {
    var data = Array<Box>(1, repeat: Box() @local!)
    data[0] = Box() @local!
    "ok"
}