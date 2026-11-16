// Copyright (c) Huawei Technologies Co., Ltd. 2026. All rights reserved.
// This source file is part of the Cangjie project, licensed under Apache-2.0
// with Runtime Library Exception.
//
// See https://cangjie-lang.cn/pages/LICENSE for license information.

// EXEC: %compiler %local %f -o %output
// RUN-EXEC: %run %run_opt %output %run_args

class NC {
    init() {}
    init(this @local!) { exclave { } }
}

class Worker {
    static func consume(a: NC@local!) {}
    init() {}
}

func run() {
    Worker.consume(NC() @local!)
}

main(): Int64 {
    run()
    0
}
