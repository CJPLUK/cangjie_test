// Copyright (c) Huawei Technologies Co., Ltd. 2026. All rights reserved.
// This source file is part of the Cangjie project, licensed under Apache-2.0
// with Runtime Library Exception.
//
// See https://cangjie-lang.cn/pages/LICENSE for license information.

// ERRCHECK: %compiler %local %f %diag_json --error-count-limit=all 2>&1

func full_full(x: ((String) @local!) @local!) {}
func full_half(x: ((String) @local!) @local?) {}
func full_not(x: ((String) @local!) @~local) {}
func half_full(x: ((String) @local?) @local!) {}
func half_half(x: ((String) @local?) @local?) {}
func half_not(x: ((String) @local?) @~local) {}
func not_full(x: ((String) @~local) @local!) {}
func not_half(x: ((String) @~local) @local?) {}
func not_not(x: ((String) @~local) @~local) {}
func deep_same(x: (((String) @local!)) @local!) {}
func deep_different(x: (((String) @local!)) @local?) {}
func three_modes(x: (((String) @local!) @local?) @~local) {}

main() {}

// ASSERT: scan-13 "DiagKind": "parse_unexpected_modal_type",
// ASSERT: scan "Errors": 13,
