// Copyright (c) Huawei Technologies Co., Ltd. 2026. All rights reserved.
// This source file is part of the Cangjie project, licensed under Apache-2.0
// with Runtime Library Exception.
//
// See https://cangjie-lang.cn/pages/LICENSE for license information.

// LEVEL: 0
// ERRCHECK: %compiler %local %typecheck %f -Woff all %diag_json 2>&1

package std.math

@Intrinsic
func write<T>(array: Array<T> @local!, value: T @local!): Unit

@Intrinsic
func write<T>(array: Array<T> @local!, value: T @local!): Unit

// ASSERT: scan "DiagKind": "sema_overload_conflicts",
// ASSERT: scan "Errors": 1,
