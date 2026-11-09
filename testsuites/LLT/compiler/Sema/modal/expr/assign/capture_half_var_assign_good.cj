// Copyright (c) Huawei Technologies Co., Ltd. 2026. All rights reserved.
// This source file is part of the Cangjie project, licensed under Apache-2.0
// with Runtime Library Exception.
//
// See https://cangjie-lang.cn/pages/LICENSE for license information.

// EXEC: %compiler %local %f -o %output

func assignLocal() {
    var view: String @local? = "a"
    @local? func update() {
        let next: String = "b"
        view = next
    }
    update()
}

func assignCopy() {
    var n: Int64 @local? = 0
    @local? func update() {
        let next: Int64 @local! = 1
        n = next
    }
    update()
}

main() {
    assignLocal()
    assignCopy()
}
