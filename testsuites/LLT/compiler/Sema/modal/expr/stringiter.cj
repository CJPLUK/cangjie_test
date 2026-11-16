// Copyright (c) Huawei Technologies Co., Ltd. 2026. All rights reserved.
// This source file is part of the Cangjie project, licensed under Apache-2.0
// with Runtime Library Exception.
//
// See https://cangjie-lang.cn/pages/LICENSE for license information.

// EXEC: %compiler %local %f -o %output
// RUN-EXEC: %run %run_opt %output %run_args
func validateJsonStringFormat(indent: String @local?): Unit {
    for (item in indent) {
        print(item)
    }
}
exclave func bar(indent: String @local!) {
    for (i in indent) {
        print(i)
    }
}
main() {
    validateJsonStringFormat("hello")
    bar("hello")
}