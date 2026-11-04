// Copyright (c) Huawei Technologies Co., Ltd. 2026. All rights reserved.
// This source file is part of the Cangjie project, licensed under Apache-2.0
// with Runtime Library Exception.
//
// See https://cangjie-lang.cn/pages/LICENSE for license information.

// Returning an internal local value as a non copy interface type would box it in the current region.

// ERRCHECK: %compiler %local %f -Woff all %diag_json 2>&1

func full(): ToString {
    let n: Int64 @local! = 1
    n
}

func maybe(): ToString @local? {
    let n: Int64 @local? = 1
    n
}

main() {}

// ASSERT: scan-2 "DiagKind": "sema_internal_local_return",
// ASSERT: scan "Errors": 2,
