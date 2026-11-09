// Copyright (c) Huawei Technologies Co., Ltd. 2026. All rights reserved.
// This source file is part of the Cangjie project, licensed under Apache-2.0
// with Runtime Library Exception.
//
// See https://cangjie-lang.cn/pages/LICENSE for license information.

// ERRCHECK: %compiler %local %f -Woff all %diag_json 2>&1

func f(x: (Int64) -> Int64 -> Int64) {}

main() {}

// ASSERT: scan-1 "DiagKind": "parse_redundant_arrow_after_func_type",
// ASSERT: scan "Errors": 3,
