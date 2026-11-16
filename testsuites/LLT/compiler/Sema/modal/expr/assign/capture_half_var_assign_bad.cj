// Copyright (c) Huawei Technologies Co., Ltd. 2026. All rights reserved.
// This source file is part of the Cangjie project, licensed under Apache-2.0
// with Runtime Library Exception.
//
// See https://cangjie-lang.cn/pages/LICENSE for license information.

// ERRCHECK: %compiler %local %f -Woff all %diag_json 2>&1

func assignExternalLocal() {
    var view: String @local? = "a"
    @local? func update() {
        let next: String @local! = "b"
        view = next
    }
    update()
}

func assignLocalHalf() {
    var view: String @local? = "a"
    @local? func update() {
        var next: String @local? = "b"
        view = next
    }
    update()
}

main() {}

// ASSERT: scan-2 "DiagKind": "sema_bad_local_assignment",
// ASSERT: scan "Errors": 2,
