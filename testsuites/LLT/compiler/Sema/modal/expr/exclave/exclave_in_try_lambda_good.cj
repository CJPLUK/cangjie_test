// Copyright (c) Huawei Technologies Co., Ltd. 2026. All rights reserved.
// This source file is part of the Cangjie project, licensed under Apache-2.0
// with Runtime Library Exception.
//
// See https://cangjie-lang.cn/pages/LICENSE for license information.

// EXEC: %compiler %local %f -o %output

exclave func foo(a: Int): String @local? {
    try {
        let f: () -> String @local? = { => exclave { "ok" } }
        f()
    } catch (_) {
        "err"
    }
}

main() {}
