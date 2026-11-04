// Copyright (c) Huawei Technologies Co., Ltd. 2026. All rights reserved.
// This source file is part of the Cangjie project, licensed under Apache-2.0
// with Runtime Library Exception.
//
// See https://cangjie-lang.cn/pages/LICENSE for license information.

// EXEC-PIPE-1: %compiler %local %f %diag_json -Woff all 2>&1 | compare %f

func f1(a: VArray<Int @local?, $4>) {}
func f2(a: VArray<Int @local!, $2>) {}
func f3(a: VArray<Int @~local, $1>) {}

main() {}

// ASSERT: scan-3 "DiagKind": "parse_unexpected_modal_type",
// ASSERT: scan "Errors": 3,
