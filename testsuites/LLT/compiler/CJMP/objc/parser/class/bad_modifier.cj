// Copyright (c) Huawei Technologies Co., Ltd. 2025. All rights reserved.
// This source file is part of the Cangjie project, licensed under Apache-2.0
// with Runtime Library Exception.
//
// See https://cangjie-lang.cn/pages/LICENSE for license information.

// (CJNATIVE and not Windows) EXEC-PIPE-1: %compiler %cmp_opt %diag_json %f -o %output 2>& 1 | compare %f

@ObjC
sealed abstract foreign class M {
}

@ObjC
sealed abstract class Impl {
}

// ASSERT: scan parse_objc_mirror_cannot_be_sealed
// ASSERT: scan parse_objc_impl_cannot_be_abstract
// ASSERT: scan "Errors": 2
