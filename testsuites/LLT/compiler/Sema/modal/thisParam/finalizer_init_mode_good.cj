// Copyright (c) Huawei Technologies Co., Ltd. 2026. All rights reserved.
// This source file is part of the Cangjie project, licensed under Apache-2.0
// with Runtime Library Exception.
//
// See https://cangjie-lang.cn/pages/LICENSE for license information.

// EXEC: %compiler %local %cmp_opt %f -o %output
// RUN-EXEC: %run %run_opt %output %run_args

class C {
    init() {}
    init(this @local!) {
        exclave {}
    }
    ~init(this @local?) {}
}
class D {
    init(this @local!) {
        exclave {}
    }
    ~init(this @local!) {}
}
main() {}
