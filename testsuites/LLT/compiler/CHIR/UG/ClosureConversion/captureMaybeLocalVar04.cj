// Copyright (c) Huawei Technologies Co., Ltd. 2026. All rights reserved.
// This source file is part of the Cangjie project, licensed under Apache-2.0
// with Runtime Library Exception.
//
// See https://cangjie-lang.cn/pages/LICENSE for license information.

// LEVEL: 0
// EXEC: %compiler %f %local -o %n.%suffix
// EXEC: %run %run_opt %n.%suffix

class Cell {
    init() {}
    init(this @local?) { exclave {} }
}

main() {
    var captured: Cell @local? = Cell() @~local
    @local? func read() { let c = captured }
    captured = Cell() @local?
    read()
}