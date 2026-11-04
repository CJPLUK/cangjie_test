// Copyright (c) Huawei Technologies Co., Ltd. 2026. All rights reserved.
// This source file is part of the Cangjie project, licensed under Apache-2.0
// with Runtime Library Exception.
//
// See https://cangjie-lang.cn/pages/LICENSE for license information.

// EXEC-PIPE-1: %compiler %local %f %diag_json -Woff all 2>&1 | compare %f

func f1(a: ?(String @local!)) {}
func f2(a: ?(Int @local?)) {}
func f3(a: ?(Bool @~local)) {}

main() {}

// ASSERT: scan-3 "DiagKind": "parse_unexpected_modal_type",
// ASSERT: scan "Errors": 3,
