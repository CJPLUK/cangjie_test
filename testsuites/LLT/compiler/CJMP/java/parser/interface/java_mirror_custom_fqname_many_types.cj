// Copyright (c) Huawei Technologies Co., Ltd. 2025. All rights reserved.
// This source file is part of the Cangjie project, licensed under Apache-2.0
// with Runtime Library Exception.
//
// See https://cangjie-lang.cn/pages/LICENSE for license information.

// (CJNATIVE and not Windows) EXEC-PIPE-1: %compiler %cmp_opt %diag_json %f -o %output 2>& 1 | compare %f

@Java["fqname", "anything else"]
foreign interface M {}

// ASSERT: scan parse_annotation_max_one_argument
// ASSERT: scan @Java requires zero or one 'String' literal argument
// ASSERT: scan "Errors": 1
