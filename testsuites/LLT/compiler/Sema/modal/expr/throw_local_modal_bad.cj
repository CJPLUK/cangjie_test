// Copyright (c) Huawei Technologies Co., Ltd. 2026. All rights reserved.
// This source file is part of the Cangjie project, licensed under Apache-2.0
// with Runtime Library Exception.
//
// See https://cangjie-lang.cn/pages/LICENSE for license information.

// ERRCHECK: %compiler %local %f %diag_json 2>&1

func full(e: Exception @local!) { throw e }
func half(e: Exception @local?) { throw e }
main() {}

// ASSERT: scan-2 "DiagKind": "sema_throw_expr_with_wrong_type",
// ASSERT: scan "Errors": 2,
