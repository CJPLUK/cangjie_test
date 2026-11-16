// Copyright (c) Huawei Technologies Co., Ltd. 2026. All rights reserved.
// This source file is part of the Cangjie project, licensed under Apache-2.0
// with Runtime Library Exception.
//
// See https://cangjie-lang.cn/pages/LICENSE for license information.

// ERRCHECK: %compiler %local %f %diag_json 2>&1

func exclave() {}
func demode() {}
main() {}

// ASSERT: scan-2 "DiagKind": "parse_expected_name",
// ASSERT: scan-2 "DiagKind": "parse_expected_decl",
// ASSERT: scan "Errors": 4,
