// Copyright (c) Huawei Technologies Co., Ltd. 2026. All rights reserved.
// This source file is part of the Cangjie project, licensed under Apache-2.0
// with Runtime Library Exception.
//
// See https://cangjie-lang.cn/pages/LICENSE for license information.

// EXEC-PIPE-1: %compiler %local %f %compile_lib_opt %diag_json 2>&1 | compare %f
class Box<T> {
    init() {}
}

func f1(a: Box<Int64 @local!>) {}
func f2(a: Array<String @local?>) {}

type Alias = Option<Int64 @~local>

main() {}
// ASSERT: scan-3 "DiagKind": "parse_unexpected_modal_type",
// ASSERT: scan "Errors": 3,