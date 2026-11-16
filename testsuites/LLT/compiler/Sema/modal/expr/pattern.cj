// Copyright (c) Huawei Technologies Co., Ltd. 2026. All rights reserved.
// This source file is part of the Cangjie project, licensed under Apache-2.0
// with Runtime Library Exception.
//
// See https://cangjie-lang.cn/pages/LICENSE for license information.

// EXEC-PIPE: %compiler %local %f %diag_json 2>&1 | compare %f

exclave func pt(v: String @local!) {
    println(v.size)
}
exclave func foo(a: Any @local!) {
    match (a) {
        case s: String => pt(s)
        case _ => ()
    }
}
exclave func bar(a: ?String @local!) {
    match (a) {
        case Some(value: String) => pt(value)
        case None => ()
    }
}
main() {
    foo(3)
    bar("haha")
}

// ASSERT: scan-not "Errors"
// ASSERT: scan-not "Warnings"